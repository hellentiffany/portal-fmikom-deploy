<?php

namespace App\Http\Controllers\FASt\Admin;

use App\Http\Controllers\Controller;
use App\Models\JenisSurat;
use App\Models\SuratTemplate;
use App\Models\SuratCategory;
use App\Models\TemplateGlobalSetting;
use App\Models\Role;
use App\Services\SuratTemplateRendererService;
use App\Support\SuratDataContract;
use App\Support\TemplatePlaceholderSynchronizer;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response as HttpResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class TemplateController extends Controller
{
    protected const DEFAULT_GLOBAL_SETTINGS = [
        [
            'key'   => 'kode_prefix_nomor_surat',
            'label' => 'Prefix Nomor Surat',
            'value' => 'B',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'kode_fakultas_nomor_surat',
            'label' => 'Kode Fakultas Nomor Surat',
            'value' => 'Ybk.041.10',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'nama_instansi_footer',
            'label' => 'Nama Instansi (Footer)',
            'value' => 'Universitas Nahdlatul Ulama Al Ghazali Cilacap',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'alamat_footer',
            'label' => 'Alamat (Footer)',
            'value' => 'Jl. Kemerdekaan Barat No.17, Cilacap Tengah',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'telepon',
            'label' => 'Telepon',
            'value' => '(0282) 695415, 695407',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'website',
            'label' => 'Website',
            'value' => 'https://unugha.ac.id',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'email',
            'label' => 'Email',
            'value' => 'fmikom@unugha.ac.id',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'fax',
            'label' => 'Fax',
            'value' => '(0282) 695407',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'logo_kop_position',
            'label' => 'Posisi Logo Kop',
            'value' => 'top',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_family_all',
            'label' => 'Font Semua Bagian',
            'value' => 'Times New Roman',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_family_kop',
            'label' => 'Font Kop',
            'value' => 'Times New Roman',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_family_body',
            'label' => 'Font Isi Surat',
            'value' => 'Times New Roman',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_family_footer',
            'label' => 'Font Footer',
            'value' => 'Times New Roman',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_size_kop_instansi',
            'label' => 'Ukuran Font Kop Instansi',
            'value' => '17pt',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_size_kop_fakultas',
            'label' => 'Ukuran Font Kop Fakultas',
            'value' => '13pt',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_size_footer_instansi',
            'label' => 'Ukuran Font Footer Instansi',
            'value' => '8.8pt',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'font_size_footer_detail',
            'label' => 'Ukuran Font Footer Detail',
            'value' => '7.0pt',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'kop_border_thickness',
            'label' => 'Ketebalan Garis Kop',
            'value' => '2px',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'footer_border_thickness',
            'label' => 'Ketebalan Garis Footer',
            'value' => '2px',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'line_height_paragraf',
            'label' => 'Line Height Paragraf',
            'value' => '1.45',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'line_height_tabel',
            'label' => 'Line Height Tabel',
            'value' => '1.65',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'line_height_header',
            'label' => 'Line Height Header',
            'value' => '1.65',
            'tipe'  => 'text',
        ],
        [
            'key'   => 'line_height_yth',
            'label' => 'Line Height Yth',
            'value' => '1.05',
            'tipe'  => 'text',
        ],
    ];

    public function __construct(
        protected SuratTemplateRendererService $templateRenderer,
    ) {
    }

    protected function ensureGlobalSettingsExist(): void
    {
        foreach (self::DEFAULT_GLOBAL_SETTINGS as $setting) {
            $model = TemplateGlobalSetting::firstOrNew(['key' => $setting['key']]);

            if (! $model->exists || blank($model->label)) {
                $model->label = $setting['label'];
            }

            if (! $model->exists || blank($model->tipe)) {
                $model->tipe = $setting['tipe'];
            }

            if (! $model->exists || blank($model->value)) {
                $model->value = $setting['value'];
            }

            $model->save();
        }
    }

    /**
     * @return array<int, int>
     */
    protected function templateApprovalRoleIds(): array
    {
        return Role::query()
            ->whereIn('slug', ['admin', 'dekan', 'kaprodi'])
            ->orderBy('nama')
            ->pluck('id')
            ->map(fn ($id): int => (int) $id)
            ->values()
            ->all();
    }

    /**
     * @return array<int, int>
     */
    protected function templateAllowedCreatorRoleIds(): array
    {
        return Role::query()
            ->whereIn('slug', ['admin', 'dosen', 'mahasiswa'])
            ->orderBy('nama')
            ->pluck('id')
            ->map(fn ($id): int => (int) $id)
            ->values()
            ->all();
    }

    // ── Index ─────────────────────────────────────────────────────────────────
    public function index(Request $request): Response
    {
        $this->ensureGlobalSettingsExist();
        $approvalRoleSlugs = ['admin', 'dekan', 'kaprodi'];
        $creatorRoleSlugs  = ['mahasiswa', 'dosen', 'admin'];

        $jenisSurats = JenisSurat::query()
            ->with(['category', 'template'])
            ->orderBy('nama')
            ->get();

        // Hanya pilih jika ada jenis_surat_id di query string — tidak auto-select
        $selectedId         = (int) $request->integer('jenis_surat_id');
        $selectedJenisSurat = $selectedId > 0
            ? $jenisSurats->firstWhere('id', $selectedId)
            : null;

        return Inertia::render('admin/templates/Index', [
            'jenisSurats' => $jenisSurats->map(fn (JenisSurat $j): array => [
                'id'        => $j->id,
                'nama'      => $j->nama,
                'slug'      => $j->slug,
                'is_active' => $j->is_active,
                'category'  => [
                    'id'   => $j->category?->id,
                    'nama' => $j->category?->nama,
                ],
                'template' => $j->template ? [
                    'id'         => $j->template->id,
                    'name'       => $j->template->name,
                    'version'    => $j->template->version,
                    'created_at' => optional($j->template->created_at)?->toISOString(),
                    'updated_at' => optional($j->template->updated_at)?->toISOString(),
                ] : null,
            ])->values(),
            'selectedJenisSurat'   => $selectedJenisSurat ? $this->serializeJenisSurat($selectedJenisSurat) : null,
            'selectedJenisSuratId' => $selectedJenisSurat?->id,
            'categories'           => SuratCategory::orderBy('urutan')->get(['id', 'nama']),
            'approvalRoles'        => Role::query()
                ->whereIn('slug', $approvalRoleSlugs)
                ->orderBy('nama')
                ->get(['id', 'nama', 'slug']),
            'creatorRoles'         => Role::query()
                ->whereIn('slug', $creatorRoleSlugs)
                ->orderBy('nama')
                ->get(['id', 'nama', 'slug']),
            'globalSettings'       => TemplateGlobalSetting::orderBy('id')
                                        ->get(['key', 'label', 'value', 'tipe'])
                                        ->toArray(),
        ]);
    }

    // ── Store ─────────────────────────────────────────────────────────────────
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'nama'             => ['required', 'string', 'max:255'],
            'kode_surat'       => ['nullable', 'string', 'max:50'],
            'kode_klasifikasi' => ['nullable', 'string', 'max:50'],
            'category_id'      => ['nullable', 'exists:surat_categories,id'],
            'deskripsi'        => ['nullable', 'string'],
            'allowed_role_id'  => ['nullable', 'integer', Rule::in($this->templateAllowedCreatorRoleIds())],
            'approval_role_id' => ['nullable', 'integer', Rule::in($this->templateApprovalRoleIds())],
            'perlu_approval'   => ['nullable', 'boolean'],
            'is_active'        => ['nullable', 'boolean'],
        ]);

        $jenisSurat = JenisSurat::create([
            'nama'             => $validated['nama'],
            'slug'             => Str::slug($validated['nama']) . '-' . time(),
            'kode_surat'       => $validated['kode_surat'] ?? null,
            'kode_klasifikasi' => $validated['kode_klasifikasi'] ?? null,
            'category_id'      => $validated['category_id'] ?? null,
            'deskripsi'        => $validated['deskripsi'] ?? null,
            'allowed_role_id'  => $validated['allowed_role_id'] ?? null,
            'approval_role_id' => $validated['approval_role_id'] ?? null,
            'perlu_approval'   => $request->boolean('perlu_approval', false),
            'is_active'        => $request->boolean('is_active', true),
            'alur_pengajuan'   => 'submission',
            'field_config'     => [],
        ]);

        return redirect()
            ->route('admin.templates.index', ['jenis_surat_id' => $jenisSurat->id])
            ->with('success', "Jenis surat \"{$jenisSurat->nama}\" berhasil ditambahkan.");
    }

    // ── Update ────────────────────────────────────────────────────────────────
    public function update(Request $request, JenisSurat $jenisSurat): RedirectResponse
    {
        $request->validate([
            'template_body'           => ['required', 'string'],
            'name'                    => ['nullable', 'string', 'max:255'],
            'jenis_surat_nama'       => ['nullable', 'string', 'max:255'],
            'field_config'            => ['nullable', 'array'],
            'field_config.*.name'     => ['nullable', 'string'],
            'field_config.*.label'    => ['nullable', 'string'],
            'field_config.*.type'     => ['nullable', 'string'],
            'field_config.*.required' => ['nullable', 'boolean'],
            'field_config.*.repeatable' => ['nullable', 'boolean'],
            'field_config.*.add_label'  => ['nullable', 'string'],
            'field_config.*.item_label' => ['nullable', 'string'],
            'field_config.*.placeholder' => ['nullable', 'string'],
            'field_config.*.help' => ['nullable', 'string'],
            'field_config.*.options' => ['nullable', 'array'],
            'field_config.*.sumber_data' => ['nullable', 'in:data_pemohon,data_kampus,data_sistem'],
            'field_config.*.editable_role' => ['nullable', 'in:mahasiswa,admin,sistem'],
            'field_config.*.mode_form_pemohon' => ['nullable', 'in:editable,readonly,hidden'],
            'allowed_role_id'         => ['nullable', 'integer', Rule::in($this->templateAllowedCreatorRoleIds())],
            'approval_role_id'        => ['nullable', 'integer', Rule::in($this->templateApprovalRoleIds())],
            'layout'                  => ['nullable', 'array'],
        ]);

        // ── Update meta jenis surat ────────────────────────────────────────
        $meta = [];
        if ($request->has('kode_surat'))      $meta['kode_surat']       = $request->input('kode_surat');
        if ($request->has('kode_klasifikasi'))$meta['kode_klasifikasi'] = $request->input('kode_klasifikasi') ?: null;
        if ($request->has('category_id'))     $meta['category_id']      = $request->input('category_id') ?: null;
        if ($request->has('approval_role_id'))$meta['approval_role_id'] = $request->input('approval_role_id') ?: null;
        if ($request->has('allowed_role_id')) $meta['allowed_role_id']  = $request->input('allowed_role_id') ?: null;
        if ($request->has('perlu_approval'))  $meta['perlu_approval']   = $request->boolean('perlu_approval');
        if ($request->has('is_active'))       $meta['is_active']        = $request->boolean('is_active');
        if ($request->filled('jenis_surat_nama')) {
            $newName = trim((string) $request->input('jenis_surat_nama'));

            if ($newName !== '' && $newName !== $jenisSurat->nama) {
                $meta['nama'] = $newName;
                $meta['slug'] = Str::slug($newName) . '-' . time();
            }
        }

        // ── Simpan field_config ────────────────────────────────────────────
        if ($request->has('field_config')) {
            $fieldConfig = collect(SuratDataContract::filterDynamicFieldConfig($request->input('field_config', [])))
                ->filter(fn ($f) => is_array($f) && !empty(trim($f['name'] ?? '')) && !empty(trim($f['label'] ?? '')))
                ->map(fn ($f) => SuratDataContract::normalizeDynamicFieldConfigItem($f))
                ->values()
                ->all();

            $duplicateNames = collect($fieldConfig)
                ->map(fn (array $field): string => strtolower(trim((string) ($field['name'] ?? ''))))
                ->filter(fn (string $name): bool => $name !== '')
                ->countBy()
                ->filter(fn (int $count): bool => $count > 1)
                ->keys()
                ->values();

            if ($duplicateNames->isNotEmpty()) {
                throw ValidationException::withMessages([
                    'field_config' => 'Key field dinamis harus unik. Duplikat: '.$duplicateNames->implode(', '),
                ]);
            }

            $meta['field_config'] = $fieldConfig;
        }

        if (!empty($meta)) {
            $jenisSurat->update($meta);
        }

        // ── Simpan template body ───────────────────────────────────────────
        $templateName   = trim($request->input('name', '')) ?: $jenisSurat->nama;
        $templateBody   = $request->input('template_body');
        $activeTemplate = $jenisSurat->template()->first();

        if ($activeTemplate === null) {
            $nextVersion = (int) SuratTemplate::query()
                ->where('jenis_surat_id', $jenisSurat->id)
                ->max('version') + 1;

            $template = SuratTemplate::query()->create([
                'jenis_surat_id'  => $jenisSurat->id,
                'name'            => $templateName,
                'slug'            => sprintf('template-%s-v%d', $jenisSurat->slug ?: Str::slug($jenisSurat->nama), $nextVersion),
                'format'          => 'html',
                'template_header' => $request->input('template_header'),
                'template_body'   => $templateBody,
                'template_footer' => $request->input('template_footer'),
                'version'         => max(1, $nextVersion),
                'is_active'       => true,
            ]);
        } else {
            $activeTemplate->name            = $templateName;
            $activeTemplate->template_header = $request->input('template_header');
            $activeTemplate->template_body   = $templateBody;
            $activeTemplate->template_footer = $request->input('template_footer');

            if ($activeTemplate->isDirty(['template_body', 'template_header', 'template_footer'])) {
                $activeTemplate->version = (int) $activeTemplate->version + 1;
            }

            $activeTemplate->save();
            $template = $activeTemplate;
        }

        TemplatePlaceholderSynchronizer::syncTemplate(
            $template,
            $jenisSurat->field_config ?? []
        );

        // ── Simpan layout (margin & indent) ke css_style
        if ($request->has('layout')) {
            $layout = $request->input('layout', []);
            $css = [];

            $marginTop    = trim((string) ($layout['margin_top']    ?? ''));
            $marginRight  = trim((string) ($layout['margin_right']  ?? ''));
            $marginBottom = trim((string) ($layout['margin_bottom'] ?? ''));
            $marginLeft   = trim((string) ($layout['margin_left']   ?? ''));

            if ($marginTop || $marginRight || $marginBottom || $marginLeft) {
                $mt = $marginTop    ?: '12mm';
                $mr = $marginRight  ?: '15mm';
                $mb = $marginBottom ?: '25mm';
                $ml = $marginLeft   ?: '15mm';
                $css[] = "@page { margin: {$mt} {$mr} {$mb} {$ml}; size: A4 portrait; }";
            }

            $bodyIndent = (int) ($layout['body_indent'] ?? 0);
            if ($bodyIndent > 0) {
                $css[] = ".surat-content { padding-left: {$bodyIndent}px; padding-right: {$bodyIndent}px; }";
            }

            $paraIndent = (int) ($layout['paragraph_indent'] ?? 0);
            if ($paraIndent > 0) {
                $css[] = ".surat-paragraf { text-indent: {$paraIndent}px; }";
            }

            $tableIndent = (int) ($layout['table_indent'] ?? 0);
            if ($tableIndent > 0) {
                $css[] = ".surat-tabel { margin-left: {$tableIndent}px; }";
            }

            // $jenisSurat->template?->update(['css_style' => implode("", $css)]);
            $jenisSurat->template?->update(['css_style' => implode("\n", $css)]);
        }

        return to_route('admin.templates.index', ['jenis_surat_id' => $jenisSurat->id])
            ->with('success', 'Template surat berhasil disimpan.');
    }

    // ── Preview ───────────────────────────────────────────────────────────────
    public function preview(JenisSurat $jenisSurat): HttpResponse
    {
        $template = $jenisSurat->template()->with('placeholders')->firstOrFail();
        $rendered = $this->templateRenderer->renderTemplatePreview($template, 'pdf');

        return response(
            $this->templateRenderer->wrapDocumentHtml('Preview Template ' . $jenisSurat->nama, $rendered['html'], $template),
            200,
        )->header('Content-Type', 'text/html; charset=UTF-8');
    }

    // ── Destroy ───────────────────────────────────────────────────────────────
    public function destroy(JenisSurat $jenisSurat): RedirectResponse
    {
        $deletedCount = 0;
        $jenisSuratDeleted = false;
        $templateName = $jenisSurat->template?->name ?? $jenisSurat->nama;

        DB::transaction(function () use ($jenisSurat, &$deletedCount, &$jenisSuratDeleted): void {
            $template = $jenisSurat->template()
                ->withTrashed()
                ->with('placeholders')
                ->first();

            if ($template === null) {
                if ($jenisSurat->trashed() === false) {
                    $jenisSurat->delete();
                    $jenisSuratDeleted = true;
                }

                return;
            }

            $template->placeholders()->withTrashed()->get()->each->forceDelete();
            $deletedCount = (int) $template->forceDelete();

            if ($jenisSurat->trashed() === false) {
                $jenisSurat->delete();
                $jenisSuratDeleted = true;
            }
        });

        return redirect()
            ->route('admin.templates.index')
            ->with('success', $jenisSuratDeleted
                ? ($deletedCount > 0
                    ? "Template aktif \"{$templateName}\" berhasil dihapus dan jenis suratnya disembunyikan dari gallery. Surat lama, riwayat, dan arsip tetap aman."
                    : "Jenis surat \"{$templateName}\" berhasil disembunyikan dari gallery.")
                : 'Tidak ada template aktif yang perlu dihapus.');
    }

    // ── Toggle aktif/nonaktif ─────────────────────────────────────────────────
    public function toggleActive(JenisSurat $jenisSurat): RedirectResponse
    {
        $jenisSurat->update(['is_active' => !$jenisSurat->is_active]);
        $status = $jenisSurat->is_active ? 'diaktifkan' : 'dinonaktifkan';

        return redirect()
            ->route('admin.templates.index', ['jenis_surat_id' => $jenisSurat->id])
            ->with('success', "Jenis surat \"{$jenisSurat->nama}\" berhasil {$status}.");
    }

    // ── Duplikat ──────────────────────────────────────────────────────────────
    public function duplicate(JenisSurat $jenisSurat): RedirectResponse
    {
        $baru             = $jenisSurat->replicate();
        $baru->nama       = $jenisSurat->nama . ' (Salinan)';
        $baru->slug       = Str::slug($baru->nama) . '-' . time();
        $baru->kode_surat = $jenisSurat->kode_surat ? $jenisSurat->kode_surat . '-COPY' : null;
        $baru->kode_klasifikasi = $jenisSurat->kode_klasifikasi;
        $baru->is_active  = false;
        $baru->save();

        if ($jenisSurat->template) {
            $templateBaru                 = $jenisSurat->template->replicate();
            $templateBaru->jenis_surat_id = $baru->id;
            $templateBaru->slug           = Str::slug($baru->nama) . '-tmpl-' . time();
            $templateBaru->is_active      = false;
            $templateBaru->version        = 1;
            $templateBaru->save();

        }

        return redirect()
            ->route('admin.templates.index', ['jenis_surat_id' => $baru->id])
            ->with('success', "Jenis surat \"{$baru->nama}\" berhasil diduplikat.");
    }

    // ── Serialize ─────────────────────────────────────────────────────────────
    protected function serializeJenisSurat(JenisSurat $jenisSurat): array
    {
        $jenisSurat->loadMissing(['category', 'template.placeholders', 'approvalRole', 'allowedRole']);

        return [
            'id'             => $jenisSurat->id,
            'nama'           => $jenisSurat->nama,
            'slug'           => $jenisSurat->slug,
            'kode_surat'     => $jenisSurat->kode_surat,
            'kode_klasifikasi' => $jenisSurat->kode_klasifikasi,
            'deskripsi'      => $jenisSurat->deskripsi,
            'is_active'      => $jenisSurat->is_active,
            'perlu_approval' => $jenisSurat->perlu_approval,
            'created_at'     => optional($jenisSurat->created_at)?->toISOString(),
            'updated_at'     => optional($jenisSurat->updated_at)?->toISOString(),
            'category' => [
                'id'   => $jenisSurat->category?->id,
                'nama' => $jenisSurat->category?->nama,
            ],
            'approval_role' => [
                'id'   => $jenisSurat->approvalRole?->id,
                'nama' => $jenisSurat->approvalRole?->nama,
                'slug' => $jenisSurat->approvalRole?->slug,
            ],
            'allowed_role' => [
                'id'   => $jenisSurat->allowedRole?->id,
                'nama' => $jenisSurat->allowedRole?->nama,
            ],
            'field_config' => collect(SuratDataContract::filterDynamicFieldConfig($jenisSurat->field_config ?? []))
                ->map(fn (array $f): array => SuratDataContract::normalizeDynamicFieldConfigItem($f))
                ->values()
                ->all(),
            'template' => $jenisSurat->template ? [
                'id'               => $jenisSurat->template->id,
                'name'             => $jenisSurat->template->name,
                'source_reference' => $jenisSurat->template->source_reference,
                'subject'          => $jenisSurat->template->subject,
                'template_header'  => $jenisSurat->template->template_header,
                'template_body'    => $jenisSurat->template->template_body,
                'template_footer'  => $jenisSurat->template->template_footer,
                'template_components' => $this->decodeTemplateComponents(
                    (string) $jenisSurat->template->template_body,
                ),
                'version'          => $jenisSurat->template->version,
                'css_style'        => $jenisSurat->template->css_style,
                'created_at'       => optional($jenisSurat->template->created_at)?->toISOString(),
                'updated_at'       => optional($jenisSurat->template->updated_at)?->toISOString(),
                'preview_url'      => route('admin.templates.preview', $jenisSurat->id, absolute: false),
                'placeholders'     => $jenisSurat->template->placeholders->map(fn ($p): array => [
                    'key'           => $p->placeholder_key,
                    'label'         => $p->label,
                    'source_type'   => $p->source_type,
                    'source_key'    => $p->source_key,
                    'is_required'   => $p->is_required,
                    'default_value' => $p->default_value,
                ])->values(),
            ] : null,
        ];
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    protected function decodeTemplateComponents(string $body): array
    {
        try {
            $decoded = json_decode($body, true, 512, JSON_THROW_ON_ERROR);
        } catch (\Throwable) {
            return [];
        }

        return is_array($decoded) ? $decoded : [];
    }

}
