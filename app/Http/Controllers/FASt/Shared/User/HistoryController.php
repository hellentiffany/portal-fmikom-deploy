<?php

namespace App\Http\Controllers\FASt\Shared\User;

use App\Http\Controllers\Controller;
use App\Models\Surat;
use App\Models\SuratHistory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class HistoryController extends Controller
{
    public function index(Request $request): Response
    {
        $user   = $request->user();
        abort_if($user === null, 403);

        $search = $request->string('search')->trim()->toString();
        $status = $request->string('status')->toString();

        $surats = Surat::query()
            ->with([
                'jenisSurat.approvalRole',
                'approvalFlows' => fn ($q) => $q->latest('tanggal_aksi')->latest('id'),
                'histories' => fn ($q) => $q->latest('created_at')->latest('id')->limit(8),
            ])
            ->where('pemohon_id', $user->id)
            ->when($search, fn ($q) => $q->whereHas('jenisSurat', fn ($j) => $j->where('nama', 'like', "%{$search}%"))
                ->orWhere('keperluan', 'like', "%{$search}%"))
            ->when($status, fn ($q) => $q->where('status', $status))
            ->latest('tanggal_pengajuan')
            ->latest('id')
            ->paginate(10)
            ->through(fn (Surat $surat): array => $this->transformSubmission($surat))
            ->withQueryString();

        $user->loadMissing('role');
        return Inertia::render($this->pageName(), [
            'surats'  => $surats,
            'filters' => ['search' => $search, 'status' => $status],
            'userRole' => [
                'id'   => $user->role?->id,
                'name' => $user->role?->nama,
                'slug' => $user->role?->slug,
            ],
            'endpoints' => [
                'basePath' => $this->basePath(),
            ],
        ]);
    }

    protected function pageName(): string
    {
        return 'fast/user/History';
    }

    protected function basePath(): string
    {
        return '/fast/user';
    }

    public function cancel(Request $request, int $id): RedirectResponse
    {
        $user  = $request->user();
        abort_if($user === null, 403);

        $surat = Surat::where('pemohon_id', $user->id)->findOrFail($id);

        abort_if(
            $surat->status !== Surat::STATUS_PENDING,
            422,
            'Surat hanya bisa dibatalkan jika masih menunggu validasi.'
        );

        $surat->update(['status' => Surat::STATUS_CANCELLED]);

        return back()->with('success', 'Pengajuan surat berhasil dibatalkan.');
    }

    /**
     * @return array<string, mixed>
     */
    protected function transformSubmission(Surat $surat): array
    {
        $latestRevisionFlow = $surat->latestRevisionRequestFlow();
        $latestAdminRejectionFlow = $surat->latestAdminRejectionFlow();
        $latestApproverFinalRejectionFlow = $surat->latestApproverFinalRejectionFlow();
        $latestFinalRejectionFlow = $latestAdminRejectionFlow ?? $latestApproverFinalRejectionFlow;

        return [
            'id' => $surat->id,
            'reference' => $surat->nomor_surat ?: sprintf('REQ-%05d', $surat->id),
            'jenisSurat' => $surat->jenisSurat?->nama ?? 'Surat Akademik',
            'jenisSuratId' => $surat->jenis_surat_id,
            'approvalRole' => [
                'id' => $surat->jenisSurat?->approvalRole?->id,
                'nama' => $surat->jenisSurat?->approvalRole?->nama,
                'slug' => $surat->jenisSurat?->approvalRole?->slug,
            ],
            'requiresFinalApproval' => $surat->requiresFinalApproval(),
            'status' => $surat->status,
            'keperluan' => $surat->keperluan,
            'rejectionReason' => $latestFinalRejectionFlow?->catatan,
            'revisionReason' => $latestRevisionFlow?->catatan ?? $surat->catatan_revisi,
            'rejectedByRole' => $latestRevisionFlow?->role ?? $latestFinalRejectionFlow?->role,
            'needsRevision' => $surat->status === Surat::STATUS_REVISION_REQUESTED,
            'revisionCount' => (int) $surat->revisi_ke,
            'submittedAt' => optional($surat->tanggal_pengajuan ?? $surat->created_at)?->toISOString(),
            'neededAt' => optional($surat->tanggal_kebutuhan)?->toDateString(),
            'nomor_surat' => $surat->nomor_surat,
            'canCancel' => $surat->status === Surat::STATUS_PENDING,
            'timeline' => $surat->histories
                ->map(fn (SuratHistory $history) => [
                    'action' => $history->action,
                    'label' => $history->action_label,
                    'description' => $history->keterangan,
                    'created_at' => $history->created_at?->toISOString(),
                ])->values()->all(),
        ];
    }
}
