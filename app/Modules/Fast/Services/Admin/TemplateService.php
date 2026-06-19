<?php

namespace App\Modules\Fast\Services\Admin;

use App\Models\JenisSurat;
use App\Models\Role;
use App\Models\SuratCategory;
use App\Models\SuratTemplate;
use App\Models\TemplateGlobalSetting;
use App\Modules\Fast\DTOs\SuratDataContract;
use App\Modules\Fast\Template\Renderers\SuratTemplateRendererService;
use App\Modules\Fast\Template\Resolvers\TemplatePlaceholderSynchronizer;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response as HttpResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class TemplateService
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

    public function index(Request $request): array
    {
        $this->ensureGlobalSettingsExist();

        $jenisSurats = JenisSurat::query()
            ->with(['category', 'template'])
            ->orderBy('nama')
            ->get();

        $selectedId = (int) $request->integer('jenis_surat_id');
        $selectedJenisSurat = $selectedId > 0
            ? $jenisSurats->firstWhere('id', $selectedId)
            : null;

        return [
            'jenisSurats' => $jenisSurats->map(fn (JenisSurat $jenisSurat): array => [
                'id'        => $jenisSurat->id,
                'nama'      => $jenisSurat->nama,
                'slug'      => $jenisSurat->slug,
                'is_active' => $jenisSurat->is_active,
                'category'  => [
                    'id'   => $jenisSurat->category?->id,
                    'nama' => $jenisSurat->category?->nama,
                ],
                'template' => $jenisSurat->template ? [
                    'id'         => $jenisSurat->template->id,
                    'name'       => $jenisSurat->template->name,
                    'version'    => $jenisSurat->template->version,
                    'created_at' => optional($jenisSurat->template->created_at)?->toISOString(),
                    'updated_at' => optional($jenisSurat->template->updated_at)?->toISOString(),
                ] : null,
            ])->values(),
            'selectedJenisSurat'   => $selectedJenisSurat ? $this->serializeJenisSurat($selectedJenisSurat) : null,
            'selectedJenisSuratId' => $selectedJenisSurat?->id,
            'categories'           => SuratCategory::orderBy('urutan')->get(['id', 'nama']),
            'approvalRoles'        => Role::query()
                ->whereIn('slug', ['admin', 'dekan', 'kaprodi'])
                ->orderBy('nama')
                ->get(['id', 'nama', 'slug']),
            'creatorRoles'         => Role::query()
                ->whereIn('slug', ['mahasiswa', 'dosen', 'admin'])
                ->orderBy('nama')
                ->get(['id', 'nama', 'slug']),
            'globalSettings'       => TemplateGlobalSetting::orderBy('id')
                ->get(['key', 'label', 'value', 'tipe'])
                ->toArray(),
        ];
    }

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
            'alur_pengajuan'   => 'submission',
            'field_config'     => [],
            'perlu_approval'   => $request->boolean('perlu_approval', false),
            'is_active'        => $request->boolean('is_active', true),
        ]);

        return to_route('admin.templates.index', [
            'jenis_surat_id' => $jenisSurat->id,
        ]);
    }

    public function update(Request $request, JenisSurat $jenisSurat): RedirectResponse
    {
        $request->validate([
            'template_body'              => ['required', 'string'],
            'name'                       => ['nullable', 'string', 'max:255'],
            'jenis_surat_nama'           => ['nullable', 'string', 'max:255'],
            'field_config'               => ['nullable', 'array'],
            'field_config.*.name'        => ['nullable', 'string'],
            'field_config.*.label'       => ['nullable', 'string'],
            'field_config.*.type'        => ['nullable', 'string'],
            'field_config.*.required'    => ['nullable', 'boolean'],
            'field_config.*.repeatable'  => ['nullable', 'boolean'],
            'field_config.*.add_label'   => ['nullable', 'string'],
            'field_config.*.item_label'  => ['nullable', 'string'],
            'field_config.*.placeholder' => ['nullable', 'string'],
            'field_config.*.help'        => ['nullable', 'string'],
            'field_config.*.options'     => ['nullable', 'array'],
            'field_config.*.sumber_data' => ['nullable', 'in:data_pemohon,data_kampus,data_sistem'],
            'field_config.*.editable_role' => ['nullable', 'in:mahasiswa,admin,sistem'],
            'field_config.*.mode_form_pemohon' => ['nullable', 'in:editable,readonly,hidden'],
            'allowed_role_id'            => ['nullable', 'integer', Rule::in($this->templateAllowedCreatorRoleIds())],
            'approval_role_id'           => ['nullable', 'integer', Rule::in($this->templateApprovalRoleIds())],
            'layout'                     => ['nullable', 'array'],
        ]);

        if ($request->filled('field_config')) {
            $fieldConfig = collect(SuratDataContract::filterDynamicFieldConfig($request->input('field_config', [])))
                ->map(fn (array $config): array => SuratDataContract::normalizeDynamicFieldConfigItem($config))
                ->values()
                ->all();

            $duplicatedNames = collect($fieldConfig)
                ->pluck('name')
                ->filter()
                ->countBy()
                ->filter(fn (int $count): bool => $count > 1)
                ->keys()
                ->values()
                ->all();

            if ($duplicatedNames !== []) {
                throw ValidationException::withMessages([
                    'field_config' => 'Key field dinamis harus unik. Duplikat: ' . implode(', ', $duplicatedNames),
                ]);
            }

            $jenisSurat->field_config = $fieldConfig;
        }

        $jenisSurat->fill([
            'nama'             => $request->input('name') ?: $request->input('jenis_surat_nama') ?: $jenisSurat->nama,
            'allowed_role_id'  => $request->input('allowed_role_id', $jenisSurat->allowed_role_id),
            'approval_role_id' => $request->input('approval_role_id', $jenisSurat->approval_role_id),
        ]);
        $jenisSurat->save();

        $templateBody = (string) $request->input('template_body');
        $templateHeader = (string) $request->input('template_header', '');
        $templateFooter = (string) $request->input('template_footer', '');
        $template = $jenisSurat->template()->first();
        $templateName = $request->input('name') ?: $request->input('jenis_surat_nama') ?: $jenisSurat->nama;

        if (! $template) {
            $nextVersion = (int) SuratTemplate::query()
                ->where('jenis_surat_id', $jenisSurat->id)
                ->max('version') + 1;

            $template = SuratTemplate::create([
                'jenis_surat_id'   => $jenisSurat->id,
                'name'             => $templateName,
                'slug'             => sprintf('template-%s-v%d', $jenisSurat->slug ?: Str::slug($jenisSurat->nama), $nextVersion),
                'format'           => 'html',
                'template_header'  => $templateHeader,
                'template_body'    => $templateBody,
                'template_footer'  => $templateFooter,
                'subject'          => $templateName,
                'version'          => max(1, $nextVersion),
                'is_active'        => true,
                'source_reference' => null,
                'css_style'        => '',
            ]);
        } else {
            $template->fill([
                'name'            => $templateName,
                'template_header'  => $templateHeader,
                'template_body'    => $templateBody,
                'template_footer'  => $templateFooter,
                'subject'          => $templateName,
            ]);

            if ($template->isDirty(['template_body', 'template_header', 'template_footer'])) {
                $template->version = (int) $template->version + 1;
            }

            $template->save();
        }

        TemplatePlaceholderSynchronizer::syncTemplate($template, $jenisSurat->field_config ?? []);

        if ($request->filled('layout')) {
            $css = $this->buildLayoutCss((array) $request->input('layout', []));

            if ($css !== null) {
                $template->fill([
                    'css_style' => $css,
                ])->save();
            }
        }

        return to_route('admin.templates.index', [
            'jenis_surat_id' => $jenisSurat->id,
        ])->with('success', 'Template surat berhasil disimpan.');
    }

    public function preview(JenisSurat $jenisSurat): HttpResponse
    {
        $template = $jenisSurat->template()->with('placeholders')->firstOrFail();
        $rendered = $this->templateRenderer->renderTemplatePreview($template, 'pdf');

        return response(
            $this->templateRenderer->wrapDocumentHtml('Preview Template ' . $jenisSurat->nama, $rendered['html'], $template),
            200,
        )->header('Content-Type', 'text/html; charset=UTF-8');
    }

    public function destroy(JenisSurat $jenisSurat): RedirectResponse
    {
        DB::transaction(function () use ($jenisSurat): void {
            $template = $jenisSurat->template()->withTrashed()->with('placeholders')->first();

            if ($template) {
                $template->placeholders()->forceDelete();
                $template->forceDelete();
            }

            if (! $jenisSurat->trashed()) {
                $jenisSurat->delete();
            }
        });

        return to_route('admin.templates.index')->with('success', 'Jenis surat berhasil dihapus.');
    }

    public function toggleActive(JenisSurat $jenisSurat): RedirectResponse
    {
        $jenisSurat->forceFill([
            'is_active' => ! $jenisSurat->is_active,
        ])->save();

        return to_route('admin.templates.index', [
            'jenis_surat_id' => $jenisSurat->id,
        ])->with('success', 'Status jenis surat diperbarui.');
    }

    public function duplicate(JenisSurat $jenisSurat): RedirectResponse
    {
        return DB::transaction(function () use ($jenisSurat): RedirectResponse {
            $newName = $jenisSurat->nama . ' (Salinan)';

            $copy = $jenisSurat->replicate();
            $copy->fill([
                'nama'             => $newName,
                'slug'             => Str::slug($newName) . '-' . time(),
                'kode_surat'       => $jenisSurat->kode_surat ? $jenisSurat->kode_surat . '-COPY' : null,
                'kode_klasifikasi' => $jenisSurat->kode_klasifikasi,
                'is_active'        => false,
            ])->save();

            $template = $jenisSurat->template()->first();

            if ($template) {
                $template->replicate()->fill([
                    'jenis_surat_id' => $copy->id,
                    'name'           => $newName,
                    'subject'        => $newName,
                    'slug'           => Str::slug($newName) . '-tmpl-' . time(),
                    'is_active'      => false,
                    'version'        => 1,
                ])->save();
            }

            return to_route('admin.templates.index', [
                'jenis_surat_id' => $copy->id,
            ])->with('success', 'Template surat berhasil diduplikasi.');
        });
    }

    public function serializeJenisSurat(JenisSurat $jenisSurat): array
    {
        $jenisSurat->loadMissing(['category', 'template.placeholders', 'approvalRole', 'allowedRole']);

        return [
            'id'               => $jenisSurat->id,
            'nama'             => $jenisSurat->nama,
            'slug'             => $jenisSurat->slug,
            'kode_surat'       => $jenisSurat->kode_surat,
            'kode_klasifikasi' => $jenisSurat->kode_klasifikasi,
            'deskripsi'        => $jenisSurat->deskripsi,
            'is_active'        => $jenisSurat->is_active,
            'perlu_approval'   => $jenisSurat->perlu_approval,
            'created_at'       => optional($jenisSurat->created_at)?->toISOString(),
            'updated_at'       => optional($jenisSurat->updated_at)?->toISOString(),
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
                ->map(fn (array $field): array => SuratDataContract::normalizeDynamicFieldConfigItem($field))
                ->values()
                ->all(),
            'template' => $jenisSurat->template ? [
                'id'                  => $jenisSurat->template->id,
                'name'                => $jenisSurat->template->name,
                'source_reference'     => $jenisSurat->template->source_reference,
                'subject'             => $jenisSurat->template->subject,
                'template_header'     => $jenisSurat->template->template_header,
                'template_body'       => $jenisSurat->template->template_body,
                'template_footer'     => $jenisSurat->template->template_footer,
                'template_components' => $this->decodeTemplateComponents((string) $jenisSurat->template->template_body),
                'version'             => $jenisSurat->template->version,
                'css_style'           => $jenisSurat->template->css_style,
                'created_at'          => optional($jenisSurat->template->created_at)?->toISOString(),
                'updated_at'          => optional($jenisSurat->template->updated_at)?->toISOString(),
                'preview_url'         => route('admin.templates.preview', $jenisSurat->id, absolute: false),
                'placeholders'        => $jenisSurat->template->placeholders->map(fn ($placeholder): array => [
                    'key'           => $placeholder->placeholder_key,
                    'label'         => $placeholder->label,
                    'source_type'   => $placeholder->source_type,
                    'source_key'    => $placeholder->source_key,
                    'is_required'   => $placeholder->is_required,
                    'default_value' => $placeholder->default_value,
                ])->values(),
            ] : null,
        ];
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

    protected function buildLayoutCss(array $layout): ?string
    {
        $marginTop = $layout['margin_top'] ?? 12;
        $marginRight = $layout['margin_right'] ?? 15;
        $marginBottom = $layout['margin_bottom'] ?? 25;
        $marginLeft = $layout['margin_left'] ?? 15;
        $bodyIndent = $layout['body_indent'] ?? null;
        $paragraphIndent = $layout['paragraph_indent'] ?? null;
        $tableIndent = $layout['table_indent'] ?? null;

        $css = [
            '@page {',
            sprintf('    margin: %smm %smm %smm %smm;', $marginTop, $marginRight, $marginBottom, $marginLeft),
            '}',
        ];

        if ($bodyIndent !== null && $bodyIndent !== '') {
            $css[] = '.surat-content {';
            $css[] = sprintf('    padding-left: %smm;', $bodyIndent);
            $css[] = sprintf('    padding-right: %smm;', $bodyIndent);
            $css[] = '}';
        }

        if ($paragraphIndent !== null && $paragraphIndent !== '') {
            $css[] = '.surat-paragraf {';
            $css[] = sprintf('    text-indent: %smm;', $paragraphIndent);
            $css[] = '}';
        }

        if ($tableIndent !== null && $tableIndent !== '') {
            $css[] = '.surat-tabel {';
            $css[] = sprintf('    margin-left: %smm;', $tableIndent);
            $css[] = '}';
        }

        return implode("\n", $css);
    }
}
