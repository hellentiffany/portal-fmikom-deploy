<script setup lang="ts">
// resources/js/pages/FASt/mahasiswa/Ajukan.vue
import FastLayout from '@/layouts/FASt/FastLayout.vue';
import { Head, router, useForm } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import {
    FileText,
    UploadCloud,
    X,
    Send,
    ChevronDown,
    Paperclip,
    CheckCircle2,
    Search,
    Sparkles,
    ArrowRight,
    AlertCircle,
} from 'lucide-vue-next';
type FieldOption = { label: string; value: string };
type FieldConfig = {
    name: string;
    label: string;
    type: string;
    required: boolean;
    placeholder: string;
    options: FieldOption[];
};
type JenisSuratOption = {
    id: number;
    categoryId?: number | null;
    nama: string;
    slug?: string | null;
    deskripsi?: string | null;
    fieldConfig?: FieldConfig[];
};
type CategoryOption = {
    id: number;
    nama: string;
    slug: string;
    deskripsi?: string | null;
};
const props = defineProps<{
    categories: CategoryOption[];
    jenisSurats: JenisSuratOption[];
    selectedJenisId?: number | null;
    userRole?: {
        id?: number | null;
        name?: string | null;
        slug?: string | null;
    };
    endpoints?: { basePath: string };
}>();
const basePath = computed(() => props.endpoints?.basePath ?? '/mahasiswa');
type FieldValue = string | boolean | string[] | null;
const form = useForm<{
    jenis_surat_id: string;
    keperluan: string;
    tanggal_kebutuhan: string;
    field_data: Record<string, FieldValue>;
    lampiran: File[];
}>({
    jenis_surat_id: '',
    keperluan: '',
    tanggal_kebutuhan: '',
    field_data: {},
    lampiran: [],
});
const searchQuery = ref('');
const activeCategory = ref<number | null>(null);
const filteredJenis = computed(() => {
    let list = props.jenisSurats;
    if (activeCategory.value !== null) {
        list = list.filter((j) => j.categoryId === activeCategory.value);
    }
    const q = searchQuery.value.trim().toLowerCase();
    if (q) {
        list = list.filter(
            (j) =>
                j.nama.toLowerCase().includes(q) ||
                (j.deskripsi ?? '').toLowerCase().includes(q),
        );
    }
    return list;
});
const selectedJenis = computed<JenisSuratOption | null>(
    () =>
        props.jenisSurats.find((j) => String(j.id) === form.jenis_surat_id) ??
        null,
);
function categoryName(id?: number | null): string {
    if (!id) return 'Lainnya';
    return props.categories.find((c) => c.id === id)?.nama ?? 'Lainnya';
}
function selectJenis(jenis: JenisSuratOption) {
    form.jenis_surat_id = String(jenis.id);
    form.clearErrors();
    initFieldData(jenis);
}
function scrollToForm() {
    const el = document.querySelector('[data-form-section]');
    el?.scrollIntoView({ behavior: 'smooth', block: 'start' });
}
function initFieldData(jenis: JenisSuratOption | null) {
    const values: Record<string, FieldValue> = {};
    for (const f of jenis?.fieldConfig ?? []) {
        if (f.type === 'checkbox') values[f.name] = false;
        else if (['checkbox-group', 'multiselect'].includes(f.type))
            values[f.name] = [];
        else values[f.name] = '';
    }
    form.field_data = values;
}
onMounted(() => {
    if (props.selectedJenisId) {
        form.jenis_surat_id = String(props.selectedJenisId);
        initFieldData(selectedJenis.value);
    }
});
// ── Lampiran ────────────────────────────────────────────────────────────────
const fileInput = ref<HTMLInputElement | null>(null);
function triggerFilePick() {
    fileInput.value?.click();
}
function onFilesPicked(event: Event) {
    const input = event.target as HTMLInputElement;
    if (!input.files) return;
    form.lampiran = [...form.lampiran, ...Array.from(input.files)];
    input.value = '';
}
function removeFile(index: number) {
    form.lampiran = form.lampiran.filter((_, i) => i !== index);
}
function fileSize(bytes: number): string {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}
function todayString() {
    return new Date().toISOString().slice(0, 10);
}
function submit() {
    form.post(`${basePath.value}/submissions`, {
        forceFormData: true,
        preserveScroll: true,
    });
}
function fieldError(name: string): string | undefined {
    return (form.errors as Record<string, string>)[`field_data.${name}`];
}
</script>
<template>
    <FastLayout
        title="Ajukan Surat"
        subtitle="Lengkapi data pengajuan surat akademik Anda"
        active-menu="submit"
        :breadcrumbs="[
            { label: 'Dashboard', href: `${basePath}/dashboard` },
            { label: 'Ajukan Surat' },
        ]"
    >
        <Head title="Ajukan Surat — FAST" />
        <!-- Greeting + Step hero -->
        <div
            class="mb-6 rounded-2xl border border-blue-100 bg-gradient-to-br from-blue-50 to-white p-6"
        >
            <div class="flex items-start justify-between gap-4">
                <div class="flex-1">
                    <p
                        class="flex items-center gap-1.5 text-sm font-medium text-blue-600"
                    >
                        <Sparkles class="size-4" /> Langkah 1 dari 2
                    </p>
                    <h2 class="mt-1 text-xl font-bold text-slate-900">
                        Pilih Jenis Surat
                    </h2>
                    <p class="mt-1 text-sm text-slate-500">
                        Temukan dan pilih jenis surat akademik yang ingin Anda
                        ajukan.
                    </p>
                </div>
                <div class="hidden gap-2 sm:flex">
                    <div
                        v-for="step in ['Pilih', 'Isi Data']"
                        :key="step"
                        class="flex items-center gap-1.5 rounded-full px-3 py-1.5 text-xs font-medium"
                        :class="
                            step === 'Pilih'
                                ? 'bg-blue-500 text-white'
                                : 'border border-slate-200 bg-white text-slate-400'
                        "
                    >
                        {{ step }}
                    </div>
                </div>
            </div>
        </div>
        <form class="mx-auto max-w-4xl space-y-5" @submit.prevent="submit">
            <!-- Selected detail bar -->
            <div
                v-if="selectedJenis"
                class="rounded-2xl border border-blue-200 bg-gradient-to-r from-blue-50 to-white p-5"
            >
                <div class="flex flex-col gap-4 sm:flex-row sm:items-center">
                    <div class="min-w-0 flex-1">
                        <p
                            class="text-[10px] font-semibold tracking-wider text-blue-600 uppercase"
                        >
                            {{ categoryName(selectedJenis.categoryId) }}
                        </p>
                        <p class="mt-0.5 text-base font-bold text-slate-900">
                            {{ selectedJenis.nama }}
                        </p>
                        <p
                            v-if="selectedJenis.deskripsi"
                            class="mt-1 text-xs text-slate-500"
                        >
                            {{ selectedJenis.deskripsi }}
                        </p>
                    </div>
                    <button
                        type="button"
                        class="flex shrink-0 items-center justify-center gap-2 rounded-xl bg-blue-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm shadow-blue-200 transition-colors hover:bg-blue-700 disabled:opacity-50"
                        :disabled="form.processing"
                        @click="scrollToForm"
                    >
                        Isi Form Pengajuan <ArrowRight class="size-4" />
                    </button>
                </div>
            </div>
            <!-- Search & Category tabs -->
            <div class="space-y-3">
                <div class="relative">
                    <Search
                        class="pointer-events-none absolute top-1/2 left-3.5 size-4 -translate-y-1/2 text-slate-400"
                    />
                    <input
                        v-model="searchQuery"
                        type="text"
                        placeholder="Cari jenis surat..."
                        class="h-11 w-full rounded-xl border border-slate-200 bg-white py-0 pr-10 pl-10 text-sm text-slate-700 transition outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100"
                    />
                    <button
                        v-if="searchQuery"
                        type="button"
                        class="absolute top-1/2 right-3 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                        @click="searchQuery = ''"
                    >
                        <X class="size-4" />
                    </button>
                </div>
                <!-- Category tabs -->
                <div class="scrollbar-hide flex gap-2 overflow-x-auto pb-1">
                    <button
                        type="button"
                        class="shrink-0 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                        :class="
                            activeCategory === null
                                ? 'bg-blue-500 text-white shadow-sm'
                                : 'border border-slate-200 bg-white text-slate-500 hover:border-slate-300'
                        "
                        @click="activeCategory = null"
                    >
                        Semua ({{ jenisSurats.length }})
                    </button>
                    <button
                        v-for="cat in categories"
                        :key="cat.id"
                        type="button"
                        class="shrink-0 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                        :class="
                            activeCategory === cat.id
                                ? 'bg-blue-500 text-white shadow-sm'
                                : 'border border-slate-200 bg-white text-slate-500 hover:border-slate-300'
                        "
                        @click="
                            activeCategory =
                                activeCategory === cat.id ? null : cat.id
                        "
                    >
                        {{ cat.nama }}
                    </button>
                </div>
            </div>
            <!-- Empty hint -->
            <div
                v-if="filteredJenis.length === 0"
                class="flex flex-col items-center gap-2 rounded-2xl border border-dashed border-slate-200 py-10 text-center"
            >
                <AlertCircle class="size-8 text-slate-300" />
                <p class="text-sm text-slate-400">
                    Tidak ada jenis surat yang cocok.
                </p>
                <button
                    type="button"
                    class="text-xs text-blue-600 hover:underline"
                    @click="
                        searchQuery = '';
                        activeCategory = null;
                    "
                >
                    Hapus filter
                </button>
            </div>
            <!-- Card grid -->
            <div v-else class="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                <button
                    v-for="jenis in filteredJenis"
                    :key="jenis.id"
                    type="button"
                    class="group relative overflow-hidden rounded-2xl border p-5 text-left transition-all hover:shadow-lg"
                    :class="
                        String(jenis.id) === form.jenis_surat_id
                            ? 'border-blue-300 bg-blue-50/40 shadow-sm ring-1 ring-blue-200'
                            : 'border-slate-200 bg-white hover:border-blue-200'
                    "
                    @click="selectJenis(jenis)"
                >
                    <!-- Top stripe -->
                    <div
                        class="absolute top-0 right-0 left-0 h-1"
                        :class="
                            String(jenis.id) === form.jenis_surat_id
                                ? 'bg-blue-500'
                                : 'bg-slate-300 group-hover:bg-blue-300'
                        "
                    />
                    <!-- Selected checkmark -->
                    <div
                        v-if="String(jenis.id) === form.jenis_surat_id"
                        class="absolute top-3 right-3 grid size-5 place-items-center rounded-full bg-blue-500 text-white"
                    >
                        <svg
                            class="size-3"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="3"
                                d="M5 13l4 4L19 7"
                            />
                        </svg>
                    </div>
                    <div class="flex items-start gap-3">
                        <div
                            class="grid size-12 shrink-0 place-items-center rounded-2xl border-2"
                            :class="
                                String(jenis.id) === form.jenis_surat_id
                                    ? 'border-blue-300 bg-blue-100 text-blue-700'
                                    : 'border-slate-200 bg-slate-50 text-slate-500 group-hover:border-blue-200 group-hover:bg-blue-50 group-hover:text-blue-600'
                            "
                        >
                            <FileText class="size-6" stroke-width="2.5" />
                        </div>
                        <div class="min-w-0 flex-1">
                            <p class="text-sm font-semibold text-slate-900">
                                {{ jenis.nama }}
                            </p>
                            <p class="mt-0.5 text-xs text-slate-400">
                                {{ categoryName(jenis.categoryId) }}
                            </p>
                        </div>
                    </div>
                    <p
                        v-if="jenis.deskripsi"
                        class="mt-3 line-clamp-2 text-xs text-slate-500"
                    >
                        {{ jenis.deskripsi }}
                    </p>
                </button>
            </div>
            <!-- Step 2: Isi data (muncul setelah jenis dipilih) -->
            <template v-if="selectedJenis">
                <section
                    data-form-section
                    class="space-y-3 rounded-xl border border-slate-200 bg-white p-4"
                >
                    <div class="flex items-center gap-3">
                        <div
                            class="grid size-7 place-items-center rounded-lg bg-blue-600 text-white"
                        >
                            <CheckCircle2 class="size-3.5" />
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-slate-900">
                                Data Pengajuan
                            </p>
                            <p class="text-[10px] text-slate-400">
                                Isi informasi sesuai kebutuhan surat
                            </p>
                        </div>
                    </div>
                    <!-- Keperluan -->
                    <div>
                        <label
                            class="mb-1 block text-xs font-medium text-slate-700"
                            >Keperluan
                            <span class="text-red-500">*</span></label
                        >
                        <textarea
                            v-model="form.keperluan"
                            rows="2"
                            placeholder="Jelaskan keperluan pengajuan surat (min. 10 karakter)..."
                            class="w-full resize-none rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400 focus:bg-white"
                        />
                        <p
                            v-if="form.errors.keperluan"
                            class="mt-1 text-xs text-red-500"
                        >
                            {{ form.errors.keperluan }}
                        </p>
                    </div>
                    <!-- Tanggal kebutuhan -->
                    <div>
                        <label
                            class="mb-1 block text-xs font-medium text-slate-700"
                            >Tanggal Dibutuhkan
                            <span class="text-red-500">*</span></label
                        >
                        <input
                            v-model="form.tanggal_kebutuhan"
                            type="date"
                            :min="todayString()"
                            class="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 outline-none focus:border-blue-400 focus:bg-white"
                        />
                        <p
                            v-if="form.errors.tanggal_kebutuhan"
                            class="mt-1 text-xs text-red-500"
                        >
                            {{ form.errors.tanggal_kebutuhan }}
                        </p>
                    </div>
                    <!-- Dynamic fields -->
                    <template
                        v-for="field in selectedJenis.fieldConfig ?? []"
                        :key="field.name"
                    >
                        <div>
                            <label
                                class="mb-1 block text-xs font-medium text-slate-700"
                            >
                                {{ field.label }}
                                <span v-if="field.required" class="text-red-500"
                                    >*</span
                                >
                            </label>
                            <textarea
                                v-if="field.type === 'textarea'"
                                v-model="form.field_data[field.name] as string"
                                :placeholder="field.placeholder"
                                rows="3"
                                class="w-full resize-none rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400 focus:bg-white"
                            />
                            <div
                                v-else-if="field.type === 'select'"
                                class="relative"
                            >
                                <select
                                    v-model="form.field_data[field.name]"
                                    class="h-10 w-full appearance-none rounded-xl border border-slate-200 bg-slate-50 px-3 pr-9 text-sm text-slate-900 outline-none focus:border-blue-400 focus:bg-white"
                                >
                                    <option value="">-- Pilih --</option>
                                    <option
                                        v-for="opt in field.options"
                                        :key="opt.value"
                                        :value="opt.value"
                                    >
                                        {{ opt.label }}
                                    </option>
                                </select>
                                <ChevronDown
                                    class="pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 text-slate-400"
                                />
                            </div>
                            <div
                                v-else-if="field.type === 'radio'"
                                class="flex flex-wrap gap-3 pt-1"
                            >
                                <label
                                    v-for="opt in field.options"
                                    :key="opt.value"
                                    class="flex cursor-pointer items-center gap-1.5 text-sm"
                                >
                                    <input
                                        type="radio"
                                        :value="opt.value"
                                        v-model="form.field_data[field.name]"
                                        class="text-blue-600"
                                    />
                                    {{ opt.label }}
                                </label>
                            </div>
                            <label
                                v-else-if="field.type === 'checkbox'"
                                class="flex cursor-pointer items-center gap-2 pt-1"
                            >
                                <input
                                    type="checkbox"
                                    v-model="form.field_data[field.name]"
                                    class="rounded text-blue-600"
                                />
                                <span class="text-sm text-slate-700">{{
                                    field.placeholder || field.label
                                }}</span>
                            </label>
                            <div
                                v-else-if="
                                    ['checkbox-group', 'multiselect'].includes(
                                        field.type,
                                    )
                                "
                                class="flex flex-wrap gap-3 pt-1"
                            >
                                <label
                                    v-for="opt in field.options"
                                    :key="opt.value"
                                    class="flex cursor-pointer items-center gap-1.5 text-sm"
                                >
                                    <input
                                        type="checkbox"
                                        :value="opt.value"
                                        v-model="
                                            form.field_data[
                                                field.name
                                            ] as string[]
                                        "
                                        class="rounded text-blue-600"
                                    />
                                    {{ opt.label }}
                                </label>
                            </div>
                            <input
                                v-else
                                v-model="form.field_data[field.name] as string"
                                :type="
                                    field.type === 'number'
                                        ? 'number'
                                        : field.type === 'date'
                                          ? 'date'
                                          : field.type === 'email'
                                            ? 'email'
                                            : 'text'
                                "
                                :placeholder="field.placeholder"
                                class="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400 focus:bg-white"
                            />
                            <p
                                v-if="fieldError(field.name)"
                                class="mt-1 text-xs text-red-500"
                            >
                                {{ fieldError(field.name) }}
                            </p>
                        </div>
                    </template>
                </section>
                <!-- Step 3: Upload lampiran -->
                <section
                    class="rounded-xl border border-slate-200 bg-white p-4"
                >
                    <div class="mb-3 flex items-center gap-3">
                        <div
                            class="grid size-7 place-items-center rounded-lg bg-blue-600 text-white"
                        >
                            <Paperclip class="size-3.5" />
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-slate-900">
                                Lampiran
                                <span
                                    class="text-[10px] font-normal text-slate-400"
                                    >(opsional)</span
                                >
                            </p>
                            <p class="text-[10px] text-slate-400">
                                PDF, JPG, PNG, DOC — maks. 4 MB / berkas
                            </p>
                        </div>
                    </div>
                    <input
                        ref="fileInput"
                        type="file"
                        multiple
                        class="hidden"
                        accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
                        @change="onFilesPicked"
                    />
                    <button
                        type="button"
                        class="flex w-full flex-col items-center justify-center gap-2 rounded-xl border-2 border-dashed border-slate-200 bg-slate-50 py-5 text-slate-500 transition hover:border-blue-300 hover:bg-blue-50/40"
                        @click="triggerFilePick"
                    >
                        <UploadCloud class="size-6 text-slate-400" />
                        <span class="text-xs font-medium"
                            >Klik untuk pilih berkas</span
                        >
                    </button>
                    <p
                        v-if="form.errors.lampiran"
                        class="mt-1.5 text-xs text-red-500"
                    >
                        {{ form.errors.lampiran }}
                    </p>
                    <ul v-if="form.lampiran.length" class="mt-3 space-y-2">
                        <li
                            v-for="(file, i) in form.lampiran"
                            :key="i"
                            class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2"
                        >
                            <FileText class="size-4 shrink-0 text-blue-600" />
                            <div class="min-w-0 flex-1">
                                <p
                                    class="truncate text-xs font-medium text-slate-700"
                                >
                                    {{ file.name }}
                                </p>
                                <p class="text-[10px] text-slate-400">
                                    {{ fileSize(file.size) }}
                                </p>
                            </div>
                            <button
                                type="button"
                                class="grid size-7 place-items-center rounded-lg text-slate-400 hover:bg-red-50 hover:text-red-500"
                                @click="removeFile(i)"
                            >
                                <X class="size-4" />
                            </button>
                        </li>
                    </ul>
                </section>
                <!-- Submit -->
                <div class="flex items-center justify-end gap-2 pb-2">
                    <button
                        type="button"
                        class="rounded-lg border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-600 transition hover:bg-slate-50"
                        @click="router.visit(`${basePath}/dashboard`)"
                    >
                        Batal
                    </button>
                    <button
                        type="submit"
                        :disabled="form.processing"
                        class="flex items-center gap-1.5 rounded-lg bg-blue-600 px-5 py-2 text-sm font-semibold text-white transition hover:bg-blue-700 disabled:opacity-50"
                    >
                        <Send class="size-3.5" />
                        {{
                            form.processing ? 'Mengirim...' : 'Kirim Pengajuan'
                        }}
                    </button>
                </div>
            </template>
        </form>
    </FastLayout>
</template>
<style scoped>
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}
.scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>
