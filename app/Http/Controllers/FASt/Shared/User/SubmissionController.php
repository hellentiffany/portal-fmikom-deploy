<?php

namespace App\Http\Controllers\FASt\Shared\User;

use App\Http\Controllers\Controller;
use App\Models\JenisSurat;
use App\Models\SuratCategory;
use App\Services\SuratWorkflowService;
use App\Support\SuratDataContract;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

class SubmissionController extends Controller
{
    public function __construct(
        protected SuratWorkflowService $workflow,
    ) {
    }

    /**
     * Halaman "Ajukan Surat": pilih jenis surat → isi form → upload → submit.
     */
    public function create(Request $request): Response
    {
        $user = $request->user();
        abort_if($user === null, 403);
        $user->loadMissing('role');

        $jenisSurats = $this->visibleSubmissionJenisSuratQuery($user)
            ->orderBy('nama')
            ->get(['id', 'category_id', 'nama', 'slug', 'deskripsi', 'field_config']);

        $categoryIds = $jenisSurats->pluck('category_id')->filter()->unique()->values();

        $categories = SuratCategory::query()
            ->where('is_active', true)
            ->when($categoryIds->isNotEmpty(), fn ($q) => $q->whereIn('id', $categoryIds))
            ->orderBy('urutan')
            ->orderBy('nama')
            ->get(['id', 'nama', 'slug', 'deskripsi']);

        return Inertia::render($this->pageName(), [
            'categories' => $categories->map(fn (SuratCategory $c): array => [
                'id'        => $c->id,
                'nama'      => $c->nama,
                'slug'      => $c->slug,
                'deskripsi' => $c->deskripsi,
            ])->values(),
            'jenisSurats' => $jenisSurats->map(fn (JenisSurat $j): array => [
                'id'          => $j->id,
                'categoryId'  => $j->category_id,
                'nama'        => $j->nama,
                'slug'        => $j->slug,
                'deskripsi'   => $j->deskripsi,
                'fieldConfig' => collect($this->normalizeFieldConfig($j->field_config ?? []))
                    ->map(fn (array $f): array => [
                        'name'        => $f['name'],
                        'label'       => (string) $f['label'],
                        'type'        => $f['type'],
                        'required'    => (bool) $f['required'],
                        'placeholder' => (string) ($f['placeholder'] ?? ''),
                        'options'     => collect($f['options'] ?? [])
                            ->map(fn ($o) => is_array($o)
                                ? ['label' => (string) ($o['label'] ?? $o['value'] ?? ''), 'value' => (string) ($o['value'] ?? '')]
                                : ['label' => (string) $o, 'value' => (string) $o]
                            )->filter(fn ($o) => $o['value'] !== '')->values()->all(),
                    ])->values()->all(),
            ])->values(),
            'selectedJenisId' => $request->integer('jenis') ?: null,
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

    public function store(Request $request): RedirectResponse
    {
        $user = $request->user();
        abort_if($user === null, 403);

        $validated = Validator::make($request->all(), [
            'jenis_surat_id' => [
                'required',
                'integer',
                Rule::exists('jenis_surats', 'id')->where(function ($query) use ($user) {
                    $this->applyVisibleJenisSuratFilter($query, $user);
                }),
            ],
            'keperluan' => ['required', 'string', 'min:10', 'max:1000'],
            'tanggal_kebutuhan' => ['required', 'date', 'after_or_equal:today'],
            'field_data' => ['nullable', 'array'],
            'lampiran' => ['nullable', 'array'],
            'lampiran.*' => ['file', 'max:4096', 'mimes:pdf,jpg,jpeg,png,doc,docx'],
        ], [
            'jenis_surat_id.required'        => 'Jenis surat wajib dipilih.',
            'keperluan.required'             => 'Keperluan wajib diisi.',
            'keperluan.min'                  => 'Keperluan minimal 10 karakter.',
            'keperluan.max'                  => 'Keperluan maksimal 1000 karakter.',
            'tanggal_kebutuhan.required'     => 'Tanggal kebutuhan wajib diisi.',
            'tanggal_kebutuhan.date'         => 'Format tanggal kebutuhan tidak valid.',
            'tanggal_kebutuhan.after_or_equal' => 'Tanggal kebutuhan tidak boleh di masa lalu.',
        ])->validate();

        /** @var JenisSurat $jenisSurat */
        $jenisSurat = $this->visibleSubmissionJenisSuratQuery($user)
            ->findOrFail($validated['jenis_surat_id']);

        $dynamicRules = [];
        $dynamicMessages = [];

        foreach ($this->normalizeFieldConfig($jenisSurat->field_config ?? []) as $field) {
            $key = 'field_data.'.$field['name'];
            $rules = [($field['required'] ?? false) ? 'required' : 'nullable'];

            $options = collect($field['options'] ?? [])
                ->map(fn ($option) => is_array($option) ? ($option['value'] ?? null) : $option)
                ->filter(fn ($option) => filled($option))
                ->values();

            switch ($field['type']) {
                case 'number':
                    $rules[] = 'numeric';
                    break;
                case 'date':
                    $rules[] = 'date';
                    break;
                case 'email':
                    $rules[] = 'email';
                    break;
                case 'checkbox':
                    $rules[] = 'boolean';
                    break;
                case 'checkbox-group':
                case 'multiselect':
                    $rules[] = 'array';
                    if ($options->isNotEmpty()) {
                        $dynamicRules[$key.'.*'] = [Rule::in($options->all())];
                    }
                    break;
                case 'select':
                case 'radio':
                    $rules[] = 'string';
                    if ($options->isNotEmpty()) {
                        $rules[] = Rule::in($options->all());
                    }
                    break;
                default:
                    $rules[] = 'string';
                    break;
            }

            $dynamicRules[$key] = $rules;
            $dynamicMessages[$key.'.required'] = ($field['label'] ?? $field['name']).' wajib diisi.';
        }

        Validator::make($request->all(), $dynamicRules, $dynamicMessages)->validate();

        $this->workflow->submit(
            $user,
            [
                'jenis_surat_id' => (int) $validated['jenis_surat_id'],
                'keperluan' => (string) $validated['keperluan'],
                'tanggal_kebutuhan' => $validated['tanggal_kebutuhan'],
                'data' => $request->input('field_data', []),
            ],
            $request->file('lampiran', []),
        );

        return redirect()
            ->route($this->dashboardRouteName())
            ->with('success', 'Pengajuan surat berhasil dikirim.');
    }

    protected function pageName(): string
    {
        return 'fast/user/Ajukan';
    }

    protected function basePath(): string
    {
        return '/fast/user';
    }

    protected function dashboardRouteName(): string
    {
        return 'fast.user.dashboard';
    }

    protected function visibleSubmissionJenisSuratQuery($user): Builder
    {
        $user->loadMissing('role');

        $roleId = $user->role?->id;
        $assignedOnly = $this->restrictJenisSuratToAssignedRole($user);

        return JenisSurat::query()
            ->where('is_active', true)
            ->where('alur_pengajuan', 'submission')
            ->whereHas('template')
            ->when($assignedOnly, fn (Builder $query) => $query->where('allowed_role_id', $roleId))
            ->when(! $assignedOnly && $roleId !== null, fn (Builder $query) => $query->where(fn (Builder $roleQuery) => $roleQuery
                ->whereNull('allowed_role_id')
                ->orWhere('allowed_role_id', $roleId)
            ));
    }

    protected function applyVisibleJenisSuratFilter($query, $user): void
    {
        $user->loadMissing('role');

        $roleId = $user->role?->id;
        $assignedOnly = $this->restrictJenisSuratToAssignedRole($user);

        $query->where('is_active', true)
            ->where('alur_pengajuan', 'submission')
            ->when(
                method_exists($query, 'whereHas'),
                fn ($builder) => $builder->whereHas('template'),
                fn ($builder) => $builder->whereExists(function ($templateQuery) {
                    $templateQuery->selectRaw('1')
                        ->from('surat_templates')
                        ->whereColumn('surat_templates.jenis_surat_id', 'jenis_surats.id')
                        ->where('surat_templates.is_active', true);
                })
            )
            ->when($assignedOnly, fn ($q) => $q->where('allowed_role_id', $roleId))
            ->when(! $assignedOnly && $roleId !== null, fn ($q) => $q->where(function ($roleQuery) use ($roleId) {
                $roleQuery->whereNull('allowed_role_id')
                    ->orWhere('allowed_role_id', $roleId);
            }));
    }

    protected function restrictJenisSuratToAssignedRole($user): bool
    {
        return method_exists($user, 'isLab') && method_exists($user, 'isSekfak')
            ? ($user->isLab() || $user->isSekfak())
            : false;
    }

    /**
     * @param  array<int, mixed>  $fieldConfig
     * @return array<int, array<string, mixed>>
     */
    protected function normalizeFieldConfig(array $fieldConfig): array
    {
        return collect(SuratDataContract::filterDynamicFieldConfig($fieldConfig))
            ->map(fn (array $field): array => [
                'name' => (string) $field['name'],
                'label' => $field['label'] ?? $field['name'],
                'type' => strtolower((string) ($field['type'] ?? 'text')),
                'required' => (bool) ($field['required'] ?? false),
                'options' => $field['options'] ?? [],
            ])
            ->values()
            ->all();
    }

}
