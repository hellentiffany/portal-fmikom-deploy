<?php

namespace App\Http\Controllers\FASt\Admin;

use App\Http\Controllers\Controller;
use App\Models\JenisSurat;
use App\Models\SuratCategory;
use App\Models\Surat;
use App\Models\SuratLampiran;
use App\Services\FASt\Shared\Approval\FastApprovalWorkflowService;
use App\Services\SuratTemplateRendererService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response as HttpResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

class DashboardController extends Controller
{
    public function __construct(
        protected FastApprovalWorkflowService $workflow,
        protected SuratTemplateRendererService $templateRenderer,
    ) {}

    public function index(Request $request): Response
    {
        $query = Surat::query()
            ->with(['pemohon', 'jenisSurat'])
            ->where('type', 'pengajuan')
            ->whereIn('status', [Surat::STATUS_PENDING, Surat::STATUS_REVISION_REQUESTED]);

        $search = $request->string('search')->trim()->toString();
        $categoryId = $request->integer('category_id');

        if ($categoryId > 0) {
            $query->whereHas('jenisSurat', function ($jenisSuratQuery) use ($categoryId): void {
                $jenisSuratQuery->where('category_id', $categoryId);
            });
        }

        if ($search !== '') {
            $query->whereHas('pemohon', function ($pemohonQuery) use ($search): void {
                $pemohonQuery
                    ->where('name', 'like', "%{$search}%")
                    ->orWhere('nim_nip', 'like', "%{$search}%")
                    ->orWhere('nomor_induk', 'like', "%{$search}%");
            });
        }

        $surats = $query
            ->orderByDesc('tanggal_pengajuan')
            ->orderByDesc('created_at')
            ->paginate(6)
            ->through(fn(Surat $surat): array => [
                'id' => $surat->id,
                'status' => $surat->status,
                'tanggal_pengajuan' => optional($surat->tanggal_pengajuan ?? $surat->created_at)?->toISOString(),
                'created_at' => optional($surat->created_at)?->toISOString(),
                'pemohon' => [
                    'name' => $surat->pemohon?->name,
                    'nim' => $surat->pemohon?->nim_nip ?? $surat->pemohon?->nomor_induk,
                ],
                'jenisSurat' => [
                    'id' => $surat->jenisSurat?->id,
                    'nama' => $surat->jenisSurat?->nama,
                ],
            ])
            ->withQueryString();

        // ── TAMBAHAN 1: recent history ─────────────────────────────────
        $adminActivityHistory = Surat::query()
            ->with(['pemohon', 'jenisSurat'])
            ->where('type', 'surat_keluar')
            ->where('status', Surat::STATUS_FINISHED)
            ->orderByDesc('tanggal_selesai')
            ->orderByDesc('created_at')
            ->limit(3)
            ->get()
            ->map(fn (Surat $surat): array => [
                'id' => $surat->id,
                'nomor_surat' => $surat->nomor_surat,
                'keperluan' => $surat->keperluan,
                'tanggal_selesai' => optional($surat->tanggal_selesai ?? $surat->created_at)?->toISOString(),
                'pemohon' => [
                    'name' => $surat->pemohon?->name,
                ],
                'jenisSurat' => [
                    'nama' => $surat->jenisSurat?->nama,
                ],
            ]);
        // ──────────────────────────────────────────────────────────────

        return Inertia::render('admin/dashboard/Index', [
            'surats' => $surats,
            'summary' => (function (): array {
                $counts = Surat::query()
                    ->where('type', 'pengajuan')
                    ->selectRaw("
                        COUNT(*) as total,
                        SUM(CASE WHEN status IN (?,?) THEN 1 ELSE 0 END) as pending,
                        SUM(CASE WHEN status = ? THEN 1 ELSE 0 END) as validated,
                        SUM(CASE WHEN status = ? THEN 1 ELSE 0 END) as finished,
                        SUM(CASE WHEN status IN (?,?) THEN 1 ELSE 0 END) as rejected,
                        SUM(CASE WHEN status = ? THEN 1 ELSE 0 END) as cancelled
                    ", [
                        Surat::STATUS_PENDING,
                        Surat::STATUS_REVISION_REQUESTED,
                        Surat::STATUS_VALIDATED_ADMIN,
                        Surat::STATUS_FINISHED,
                        Surat::STATUS_REJECTED_ADMIN,
                        Surat::STATUS_REJECTED_APPROVER,
                        Surat::STATUS_CANCELLED,
                    ])
                    ->first();

                $total = (int) ($counts->total ?? 0);
                $cancelled = (int) ($counts->cancelled ?? 0);

                return [
                    'total'     => $total - $cancelled,
                    'pending'   => (int) ($counts->pending ?? 0),
                    'validated' => (int) ($counts->validated ?? 0),
                    'finished'  => (int) ($counts->finished ?? 0),
                    'rejected'  => (int) ($counts->rejected ?? 0),
                    'cancelled' => $cancelled,
                ];
            })(),
            'filters' => [
                'search' => $search,
                'category_id' => $categoryId > 0 ? (string) $categoryId : '',
            ],
            'categories' => SuratCategory::query()
                ->orderBy('urutan')
                ->orderBy('nama')
                ->get(['id', 'nama'])
                ->map(fn(SuratCategory $category): array => [
                    'id' => $category->id,
                    'nama' => $category->nama,
                ])
                ->values(),
            'adminActivity' => [
                'recent' => $adminActivityHistory,
            ],
            'links' => [
                'submissionsIndex' => '/admin/surat',
                'archiveIndex' => '/admin/archive',
            ],
        ]);
    }

    public function show(int $id): \Inertia\Response
    {
        $surat = Surat::query()
            ->with(['pemohon', 'jenisSurat', 'lampirans', 'approvalFlows'])
            ->findOrFail($id);

        $isiSurat = json_decode((string) $surat->isi_surat, true);

        return \Inertia\Inertia::render('admin/dashboard/Show', [
            'id' => $surat->id,
            'nomor_surat' => $surat->nomor_surat,
            'pemohon' => [
                'name' => $surat->pemohon?->name,
                'nim' => $surat->pemohon?->nim_nip ?? $surat->pemohon?->nomor_induk,
            ],
            'jenis_surat' => $surat->jenisSurat?->nama,
            'keperluan' => $surat->keperluan,
            'isi_surat' => is_array($isiSurat) ? $isiSurat : [],
            'lampiran' => $surat->lampirans->map(fn($lampiran): array => [
                'id' => $lampiran->id,
                'name' => $lampiran->nama_file,
                'url' => route('documents.lampiran.preview', $lampiran->id, absolute: false),
                'type' => $lampiran->tipe,
            ])->values(),
            'tanggal_pengajuan' => optional($surat->tanggal_pengajuan ?? $surat->created_at)?->toISOString(),
            'status' => $surat->status,
            'latest_rejection' => (function () use ($surat): ?array {
                $latestRevisionFlow = $surat->latestRevisionRequestFlow();
                $latestAdminRejectionFlow = $surat->latestAdminRejectionFlow();
                $latestApproverFinalRejectionFlow = $surat->latestApproverFinalRejectionFlow();
                $latestRejectedFlow = $latestRevisionFlow ?? $latestAdminRejectionFlow ?? $latestApproverFinalRejectionFlow;

                if ($latestRejectedFlow === null) {
                    return null;
                }

                $isRevisionRequest = $latestRejectedFlow->status === \App\Models\SuratApprovalFlow::STATUS_REVISION_REQUESTED;

                return [
                    'role' => $latestRejectedFlow->role,
                    'label' => match ($latestRejectedFlow->role) {
                        'admin' => 'Ditolak Admin',
                        'kaprodi' => $isRevisionRequest ? 'Dikembalikan Kaprodi' : 'Ditolak Kaprodi',
                        'dekan' => $isRevisionRequest ? 'Dikembalikan Dekan' : 'Ditolak Dekan',
                        default => 'Riwayat Penolakan',
                    },
                    'type' => $isRevisionRequest ? 'revision' : 'final_reject',
                    'note' => $latestRejectedFlow->catatan,
                    'acted_at' => optional($latestRejectedFlow->tanggal_aksi ?? $latestRejectedFlow->created_at)?->toISOString(),
                ];
            })(),
            'approval_timeline' => $surat->approvalFlows
                ->sortBy([
                    ['tanggal_aksi', 'asc'],
                    ['id', 'asc'],
                ])
                ->map(function ($flow): array {
                    $label = match (true) {
                        $flow->status === 'approved' && $flow->role === 'admin' => 'Divalidasi Admin',
                        $flow->status === 'approved' && $flow->role === 'kaprodi' => 'Disetujui Kaprodi',
                        $flow->status === 'approved' && $flow->role === 'dekan' => 'Disetujui Dekan',
                        $flow->status === 'rejected_final' && $flow->role === 'admin' => 'Ditolak Admin',
                        $flow->status === 'revision_requested' && $flow->role === 'kaprodi' => 'Dikembalikan Kaprodi',
                        $flow->status === 'revision_requested' && $flow->role === 'dekan' => 'Dikembalikan Dekan',
                        $flow->status === 'rejected_final' && $flow->role === 'kaprodi' => 'Ditolak Kaprodi',
                        $flow->status === 'rejected_final' && $flow->role === 'dekan' => 'Ditolak Dekan',
                        $flow->status === 'note' => 'Catatan Approval',
                        default => (string) ($flow->keterangan ?? 'Riwayat Approval'),
                    };

                    return [
                        'id' => $flow->id,
                        'role' => $flow->role,
                        'status' => $flow->status,
                        'label' => $label,
                        'note' => $flow->catatan,
                        'acted_at' => optional($flow->tanggal_aksi ?? $flow->created_at)?->toISOString(),
                    ];
                })
                ->values(),
            'history_timeline' => $surat->histories()
                ->with('user:id,name')
                ->latest('created_at')
                ->latest('id')
                ->get()
                ->map(function ($history): array {
                    return [
                        'id' => $history->id,
                        'action' => $history->action,
                        'label' => match ($history->action) {
                            'rejected' => (string) ($history->action_label ?: 'Ditolak'),
                            'revised' => (string) ($history->action_label ?: 'Dikembalikan untuk Revisi'),
                            default => $history->action_label,
                        },
                        'description' => $history->keterangan,
                        'actor' => $history->user?->name,
                        'created_at' => optional($history->created_at)?->toISOString(),
                    ];
                })
                ->values(),
            'can_approve' => $surat->canBeValidatedByAdmin(),
            'can_edit' => $surat->status === Surat::STATUS_REVISION_REQUESTED
                && (
                    $surat->validated_by_admin_id !== null
                    || $surat->approvalFlows->contains(fn ($flow) => $flow->role === 'admin' && $flow->status === 'approved')
                )
                && $surat->latestRevisionRequestFlow() !== null,
            'previewTemplateUrl' => route('documents.surat.template-preview', $surat->id, absolute: false),
            'generatedDocumentUrl' => filled($surat->nomor_surat) || filled($surat->rendered_snapshot)
                ? (
                    $surat->status === Surat::STATUS_FINISHED
                        ? route('documents.surat.pdf', $surat->id, absolute: false)
                        : route('documents.surat.generated-document', $surat->id, absolute: false)
                )
                : null,
        ]);
    }

    public function previewTemplate(int $id): HttpResponse
    {
        $surat = Surat::query()
            ->with(['pemohon', 'jenisSurat.template.placeholders', 'dataEntries'])
            ->findOrFail($id);

        $rendered = $this->templateRenderer->renderForSurat($surat);

        return response(
            $this->templateRenderer->wrapDocumentHtml('Preview ' . $surat->jenisSurat?->nama, $rendered['html'], $surat->jenisSurat?->template),
            200,
        )->header('Content-Type', 'text/html; charset=UTF-8');
    }

    // public function previewGeneratedDocument(int $id): StreamedResponse
    // {
    //     $surat = Surat::query()->findOrFail($id);

    //     abort_unless(
    //         filled($surat->generated_file_path) && Storage::disk('public')->exists($surat->generated_file_path),
    //         404,
    //     );

    //     $filename = sprintf(
    //         '%s-%d.pdf',
    //         str_replace(' ', '-', strtolower((string) ($surat->jenisSurat?->nama ?: 'surat'))),
    //         $surat->id,
    //     );

    //     return Storage::disk('public')->response(
    //         $surat->generated_file_path,
    //         $filename,
    //         [
    //             'Content-Type' => 'application/pdf',
    //             'Content-Disposition' => 'inline; filename="'.addslashes($filename).'"',
    //         ],
    //     );
    // }

    public function previewGeneratedDocument(int $id): HttpResponse
    {
        $surat = Surat::query()
            ->with(['pemohon', 'jenisSurat.template.placeholders', 'dataEntries'])
            ->findOrFail($id);

        $snapshotHtml = trim((string) ($surat->rendered_snapshot ?? ''));
        if ($snapshotHtml !== '') {
            return response(
                $this->templateRenderer->wrapDocumentHtml(
                    ($surat->jenisSurat?->nama ?? 'Surat') . ' - ' . ($surat->nomor_surat ?? ''),
                    $snapshotHtml,
                    $surat->jenisSurat?->template,
                ),
                200,
            )->header('Content-Type', 'text/html; charset=UTF-8');
        }

        $rendered = $this->templateRenderer->renderForSurat($surat);

        return response(
            $this->templateRenderer->wrapDocumentHtml(
                ($surat->jenisSurat?->nama ?? 'Surat') . ' - ' . ($surat->nomor_surat ?? ''),
                $rendered['html'],
                $surat->jenisSurat?->template,
            ),
            200,
        )->header('Content-Type', 'text/html; charset=UTF-8');
    }

    public function downloadPdf(Request $request, int $id): \Illuminate\Http\Response|\Symfony\Component\HttpFoundation\StreamedResponse
    {
        $user  = $request->user();
        $surat = Surat::query()
            ->with(['pemohon', 'jenisSurat.template.placeholders', 'dataEntries'])
            ->findOrFail($id);

        $filename = sprintf(
            '%s-%d.pdf',
            str_replace(' ', '-', strtolower((string) ($surat->jenisSurat?->nama ?: 'surat'))),
            $surat->id,
        );
        $headers = [
            'Content-Type'        => 'application/pdf',
            'Content-Disposition' => 'inline; filename="' . addslashes($filename) . '"',
            'Cache-Control'       => 'no-store, no-cache, must-revalidate, max-age=0',
            'Pragma'              => 'no-cache',
            'Expires'             => '0',
        ];

        $templateReady = $surat->jenisSurat?->template !== null;

        // Jika template masih tersedia, PDF harus selalu digenerate ulang
        // supaya preview/detail tidak memakai file cached yang sudah lama.
        if ($templateReady) {
            $generated = app(\App\Services\SuratDocumentGeneratorService::class)->generate($surat);

            return \Illuminate\Support\Facades\Storage::disk('public')->response(
                $generated->generated_file_path,
                $filename,
                $headers,
            );
        }

        if (
            filled($surat->generated_file_path) &&
            \Illuminate\Support\Facades\Storage::disk('public')->exists($surat->generated_file_path)
        ) {
            return \Illuminate\Support\Facades\Storage::disk('public')->response(
                $surat->generated_file_path,
                $filename,
                $headers,
            );
        }

        abort_if($user === null, 403);
        abort(404);
    }

    public function previewAttachment(int $id): StreamedResponse
    {
        $lampiran = SuratLampiran::query()->findOrFail($id);

        abort_unless(Storage::disk('public')->exists($lampiran->file_path), 404);

        return Storage::disk('public')->response(
            $lampiran->file_path,
            $lampiran->nama_file,
            [
                'Content-Type' => $lampiran->tipe ?: 'application/octet-stream',
                'Content-Disposition' => 'inline; filename="' . addslashes($lampiran->nama_file) . '"',
            ],
        );
    }

    public function approve(int $id): RedirectResponse
    {
        $surat = Surat::query()->findOrFail($id);

        $this->workflow->approve($surat, FastApprovalWorkflowService::ROLE_ADMIN, request()->user());

        return back()->with('success', 'Pengajuan diverifikasi, draft surat dibentuk, dan diteruskan ke approver.');
    }

    public function reject(Request $request, int $id): RedirectResponse
    {
        $request->validate([
            'reason' => ['required', 'string'],
        ]);

        $surat = Surat::query()->findOrFail($id);

        $this->workflow->reject(
            $surat,
            FastApprovalWorkflowService::ROLE_ADMIN,
            $request->user(),
            $request->string('reason')->toString(),
        );

        return back()->with('success', 'Pengajuan berhasil ditolak.');
    }
}



