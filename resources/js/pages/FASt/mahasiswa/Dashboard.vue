<script setup lang="ts">
// resources/js/pages/FASt/mahasiswa/Dashboard.vue
import FastLayout from '@/layouts/FASt/FastLayout.vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { computed, defineAsyncComponent, nextTick, ref, watch } from 'vue';

const PdfViewer = defineAsyncComponent(
    () => import('@/components/PdfViewer.vue'),
);
import {
    FileText,
    CheckCircle2,
    XCircle,
    Plus,
    Download,
    Eye,
    AlertCircle,
    GraduationCap,
    X,
    ZoomIn,
    ZoomOut,
    RotateCcw as ResetZoom,
    ExternalLink,
    RefreshCw,
    Bell,
    Info,
    FilePlus2,
    History,
    Ban,
    UploadCloud,
    Paperclip,
    Search,
} from 'lucide-vue-next';

type Summary = {
    total: number;
    diproses: number;
    selesai: number;
    ditolak: number;
    dibatalkan: number;
};
type NoteItem = {
    catatan: string;
    oleh?: string | null;
    created_at?: string | null;
};
type LatestSubmission = {
    id: number;
    reference: string;
    jenisSurat: string;
    jenisSuratId?: number | null;
    status: string;
    keperluan: string;
    hasPdf: boolean;
    rejectionReason?: string | null;
    revisionReason?: string | null;
    rejectedByRole?: string | null;
    needsRevision?: boolean;
    revisionCount?: number;
    notes?: NoteItem[];
    timeline?: {
        action: string;
        label: string;
        description?: string | null;
        created_at?: string | null;
    }[];
    submittedAt?: string | null;
    neededAt?: string | null;
};
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
type SuratCategoryOption = {
    id: number;
    nama: string;
    slug: string;
    deskripsi?: string | null;
};
type PageProps = {
    auth: { user: { name?: string } };
    flash?: { success?: string };
};

const props = defineProps<{
    summary: Summary;
    latest: LatestSubmission[];
    categories: SuratCategoryOption[];
    jenisSurats: JenisSuratOption[];
    userRole: {
        id?: number | null;
        name?: string | null;
        slug?: string | null;
    };
    userProfile: {
        name?: string | null;
        identifierLabel?: string | null;
        identifierValue?: string | null;
    };
    endpoints: { submission: string; jenisSuratBase: string; basePath: string };
}>();

const page = usePage<PageProps>();
const showFormModal = ref(false);
const selectedJenis = ref<JenisSuratOption | null>(null);
const formStep = ref<'form' | 'preview'>('form');
const toastMessage = ref('');
const expandedReasonId = ref<number | null>(null);
const expandedNotesId = ref<number | null>(null);
let toastTimeoutId: number | null = null;

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

const latestVisible = computed(() => props.latest.slice(0, 7));

type FieldValue = string | boolean | string[] | number | null;

const submitForm = useForm<{
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

function initFormData(jenis: JenisSuratOption) {
    submitForm.jenis_surat_id = String(jenis.id);
    submitForm.keperluan = '';
    submitForm.tanggal_kebutuhan = '';
    submitForm.lampiran = [];
    const fieldValues: Record<string, FieldValue> = {};
    for (const f of jenis.fieldConfig ?? []) {
        if (f.type === 'checkbox') fieldValues[f.name] = false;
        else if (['checkbox-group', 'multiselect'].includes(f.type))
            fieldValues[f.name] = [];
        else fieldValues[f.name] = '';
    }
    submitForm.field_data = fieldValues;
}

function fieldDisplayValue(field: FieldConfig): string {
    const val = submitForm.field_data[field.name];
    if (val === null || val === undefined || val === '') return '-';
    if (Array.isArray(val)) {
        if (val.length === 0) return '-';
        const labels = val.map(
            (v) => field.options.find((o) => o.value === v)?.label ?? String(v),
        );
        return labels.join(', ');
    }
    if (field.type === 'checkbox') return val ? 'Ya' : 'Tidak';
    if (field.options.length > 0)
        return field.options.find((o) => o.value === val)?.label ?? String(val);
    return String(val);
}

function goToPreview() {
    formStep.value = 'preview';
}
function backToForm() {
    formStep.value = 'form';
}

// -- Lampiran ----------------------------------------------------------------
const fileInput = ref<HTMLInputElement | null>(null);

function triggerFilePick() {
    fileInput.value?.click();
}

function onFilesPicked(event: Event) {
    const input = event.target as HTMLInputElement;
    if (!input.files) return;
    submitForm.lampiran = [...submitForm.lampiran, ...Array.from(input.files)];
    input.value = '';
}

function removeFile(index: number) {
    submitForm.lampiran = submitForm.lampiran.filter((_, i) => i !== index);
}

function fileSize(bytes: number): string {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}
// -- End Lampiran -------------------------------------------------------------

function doSubmit() {
    submitForm.post(props.endpoints.submission, {
        forceFormData: true,
        onSuccess: () => closeForm(),
    });
}

// -- Viewer state -------------------------------------------------------------
const viewerOpen = ref(false);
const viewerUrl = ref<string | null>(null);
const viewerTitle = ref('');
const viewerMode = ref<'html' | 'pdf'>('html');
const viewerNomor = ref<string | null>(null);
const iframeZoom = ref(100);
const iframeLoad = ref(true);
const iframeError = ref(false);

function openViewer(item: LatestSubmission, mode: 'preview' | 'pdf') {
    iframeZoom.value = 100;
    iframeLoad.value = true;
    iframeError.value = false;

    if (mode === 'pdf' && item.hasPdf) {
        viewerUrl.value = `/documents/surat/${item.id}/pdf`;
        viewerMode.value = 'pdf';
    } else {
        viewerUrl.value = `/documents/surat/${item.id}/generated-document`;
        viewerMode.value = 'html';
    }
    viewerTitle.value = `${item.jenisSurat} - ${item.reference}`;
    viewerNomor.value = item.reference;
    viewerOpen.value = true;
}

function closeViewer() {
    viewerOpen.value = false;
    setTimeout(() => {
        viewerUrl.value = null;
    }, 200);
}

function openInNewTab() {
    if (viewerUrl.value) window.open(viewerUrl.value, '_blank');
}
// -- End Viewer ----------------------------------------------------------------

const firstName = computed(
    () => String(page.props.auth?.user?.name ?? 'Pengguna').split(' ')[0],
);
const roleSlug = computed(() =>
    String(props.userRole.slug ?? '').toLowerCase(),
);
const dashboardGreeting = computed(() => {
    if (roleSlug.value === 'lab') return 'Kepala Lab';
    if (roleSlug.value === 'sekfak') return 'Sekretaris Fakultas';
    return firstName.value;
});
const dashboardSubtitle = computed(() => {
    if (roleSlug.value === 'lab') return 'Unit Kerja: Laboratorium';
    if (roleSlug.value === 'sekfak') return 'Unit Kerja: Fakultas';
    return `${props.userProfile.identifierLabel ?? 'ID'}: ${
        props.userProfile.identifierValue ?? '-'
    }`;
});
const isRestrictedStaffRole = computed(() =>
    ['lab', 'sekfak'].includes(roleSlug.value),
);
const dashboardIntro = computed(() => {
    if (roleSlug.value === 'lab') {
        return 'Pantau pengajuan surat laboratorium dan aktivitas layanan Anda dalam satu platform terintegrasi.';
    }
    if (roleSlug.value === 'sekfak') {
        return 'Pantau pengajuan surat fakultas dan aktivitas layanan Anda dalam satu platform terintegrasi.';
    }
    return 'Pantau pengajuan surat dan aktivitas akademik Anda dengan mudah dalam satu platform terintegrasi.';
});

function formatDate(date?: string | null) {
    if (!date) return '-';
    return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    }).format(new Date(date));
}

// Timeline 2 tahap saja
const STATUS_STEPS = [
    { key: 'pending', short: 'Diajukan' },
    { key: 'done', short: 'Divalidasi' },
];

const DONE_STATUSES = [
    'validated_admin',
    'approved_kaprodi',
    'approved_dekan',
    'finished',
];

function getStepIndex(status: string): number {
    if (status === 'rejected_admin' || status === 'rejected_approver')
        return -1;
    if (DONE_STATUSES.includes(status)) return 1;
    return 0; // pending
}

function statusLabel(status: string) {
    const map: Record<string, string> = {
        pending: 'Menunggu Validasi',
        revision_requested: 'Sedang Direvisi Admin',
        validated_admin: 'Sudah Divalidasi',
        approved_kaprodi: 'Sudah Divalidasi',
        approved_dekan: 'Sudah Divalidasi',
        finished: 'Sudah Divalidasi',
        rejected_admin: 'Ditolak Admin',
        rejected_approver: 'Ditolak Pimpinan',
        cancelled: 'Dibatalkan',
    };
    return map[status] ?? 'Diproses';
}

function submissionStatusLabel(item: LatestSubmission) {
    if (item.status === 'revision_requested' && item.needsRevision) {
        return 'Perlu Revisi';
    }

    return statusLabel(item.status);
}

function statusBadgeClass(status: string) {
    if (status === 'revision_requested') return 'bg-amber-100 text-amber-700';
    if (status === 'rejected_admin' || status === 'rejected_approver')
        return 'bg-red-100 text-red-700';
    if (status === 'pending') return 'bg-sky-100 text-sky-700';
    if (status === 'cancelled') return 'bg-slate-100 text-slate-600';
    return 'bg-blue-100 text-blue-700';
}

async function showToast(message: string) {
    if (toastTimeoutId !== null) {
        window.clearTimeout(toastTimeoutId);
        toastTimeoutId = null;
    }
    toastMessage.value = '';
    await nextTick();
    toastMessage.value = message;
    toastTimeoutId = window.setTimeout(() => {
        toastMessage.value = '';
        toastTimeoutId = null;
    }, 3200);
}

watch(
    () => page.props.flash?.success,
    (message) => {
        if (typeof message === 'string' && message.length > 0)
            showToast(message);
    },
    { immediate: true },
);

function openForm(jenis: JenisSuratOption) {
    selectedJenis.value = jenis;
    formStep.value = 'form';
    initFormData(jenis);
    showFormModal.value = true;
}

function rejectionHeadline(item: LatestSubmission) {
    if (item.needsRevision) {
        return `Sedang direvisi admin setelah catatan ${item.rejectedByRole === 'dekan' ? 'Dekan' : 'Kaprodi'}`;
    }

    return item.rejectedByRole === 'admin'
        ? 'Pengajuan ditolak admin'
        : 'Pengajuan ditolak pimpinan';
}
function closeForm() {
    showFormModal.value = false;
    selectedJenis.value = null;
    submitForm.reset();
    submitForm.clearErrors();
}
function toggleReason(id: number) {
    expandedReasonId.value = expandedReasonId.value === id ? null : id;
}
function toggleNotes(id: number) {
    expandedNotesId.value = expandedNotesId.value === id ? null : id;
}
function todayString() {
    return new Date().toISOString().slice(0, 10);
}

function fieldError(name: string): string | undefined {
    return (submitForm.errors as Record<string, string>)[`field_data.${name}`];
}
</script>

<template>
    <FastLayout
        title="Dashboard"
        :subtitle="dashboardSubtitle"
        active-menu="dashboard"
        :breadcrumbs="[{ label: 'Dashboard' }]"
    >
        <Head title="Dashboard - FAST" />

        <!-- Greeting -->
        <div
            class="mb-6 rounded-2xl border border-blue-100 bg-blue-50 p-6 text-slate-800"
        >
            <div class="flex items-start justify-between gap-4">
                <div class="flex-1">
                    <p class="text-sm text-slate-500">
                        Selamat Datang,
                        <span class="font-semibold">{{ dashboardGreeting }}</span>
                    </p>
                    <h2
                        class="mt-1 max-w-xl text-lg font-semibold text-slate-800"
                    >
                        {{ dashboardIntro }}
                    </h2>
                </div>
                <div class="hidden shrink-0 sm:block">
                    <div
                        class="grid size-16 place-items-center rounded-2xl bg-white"
                    >
                        <GraduationCap class="size-8 text-slate-300" />
                    </div>
                </div>
            </div>

            <!-- 5 statistik -->
            <div
                class="mt-5 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5"
            >
                <div
                    v-for="stat in [
                        {
                            label: 'Total Surat',
                            value: summary.total,
                            border: 'border-blue-200',
                            icon: FileText,
                            iconColor: 'text-blue-400',
                        },
                        {
                            label: 'Diproses',
                            value: summary.diproses,
                            border: 'border-sky-200',
                            icon: RefreshCw,
                            iconColor: 'text-sky-400',
                        },
                        {
                            label: 'Selesai',
                            value: summary.selesai,
                            border: 'border-green-200',
                            icon: CheckCircle2,
                            iconColor: 'text-green-400',
                        },
                        {
                            label: 'Ditolak',
                            value: summary.ditolak,
                            border: 'border-red-200',
                            icon: XCircle,
                            iconColor: 'text-red-400',
                        },
                        {
                            label: 'Dibatalkan',
                            value: summary.dibatalkan,
                            border: 'border-slate-200',
                            icon: Ban,
                            iconColor: 'text-slate-400',
                        },
                    ]"
                    :key="stat.label"
                    class="rounded-xl border bg-white p-3"
                    :class="stat.border"
                >
                    <div class="flex items-center justify-between">
                        <p class="text-[11px] text-slate-500">
                            {{ stat.label }}
                        </p>
                        <component
                            :is="stat.icon"
                            class="size-4"
                            :class="stat.iconColor"
                        />
                    </div>
                    <p class="mt-1 text-2xl font-bold text-slate-900">
                        {{ String(stat.value).padStart(2, '0') }}
                    </p>
                </div>
            </div>
        </div>

        <!-- Main grid -->
        <div class="grid gap-6 xl:grid-cols-[1fr_300px]">
            <!-- Kiri: Pengajuan Terbaru -->
            <div
                class="overflow-hidden rounded-2xl border border-slate-200 bg-white"
            >
                <!-- Toolbar -->
                <div
                    class="flex flex-col gap-3 border-b border-slate-100 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
                >
                    <div>
                        <h2 class="text-sm font-semibold text-slate-900">
                            Pengajuan Terbaru
                        </h2>
                        <p class="mt-0.5 text-xs text-slate-400">
                            {{ latestVisible.length }} pengajuan
                        </p>
                    </div>
                    <Link
                        :href="`${props.endpoints.basePath}/history`"
                        class="inline-flex shrink-0 items-center gap-1.5 rounded-xl bg-blue-600 px-4 py-2 text-xs font-semibold text-white transition-colors hover:bg-blue-700"
                    >
                        <History class="size-3.5" />
                        Lihat Semua
                    </Link>
                </div>

                <!-- Perlu Revisi banner -->
                <div
                    v-if="latestVisible.some((i) => i.needsRevision)"
                    class="mx-5 mt-3 rounded-xl border border-red-100 bg-red-50 px-3 py-2"
                >
                    <div class="flex items-center gap-2">
                        <AlertCircle class="size-3.5 shrink-0 text-red-500" />
                        <p class="text-xs font-medium text-red-700">
                            Ada pengajuan yang perlu direvisi.
                        </p>
                    </div>
                </div>

                <!-- Riwayat Pengajuan Table -->
                <div
                    v-if="latest.length === 0"
                    class="px-5 py-12 text-center text-sm text-slate-400"
                >
                    <FileText class="mx-auto mb-3 size-10 text-slate-300" />
                    <p class="font-medium text-slate-500">
                        Belum ada pengajuan surat
                    </p>
                </div>

                <div v-else class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-slate-50">
                            <tr
                                class="text-[10px] font-semibold tracking-widest text-slate-400 uppercase"
                            >
                                <th class="w-12 px-5 py-3">No</th>
                                <th class="px-5 py-3">Jenis Surat</th>
                                <th class="w-36 px-5 py-3">Tanggal</th>
                                <th class="w-40 px-5 py-3">Status</th>
                                <th class="px-5 py-3 text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template
                                v-for="(item, i) in latestVisible"
                                :key="item.id"
                            >
                                <tr
                                    class="border-t border-slate-100 text-sm transition-colors hover:bg-slate-50/50"
                                >
                                    <td
                                        class="px-5 py-3.5 text-xs text-slate-500"
                                    >
                                        {{ i + 1 }}
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <p
                                            class="text-xs font-semibold text-slate-900"
                                        >
                                            {{ item.jenisSurat }}
                                        </p>
                                        <p class="text-[10px] text-slate-400">
                                            {{ item.reference }}
                                        </p>
                                        <p
                                            v-if="item.keperluan"
                                            class="text-[10px] text-slate-400"
                                        >
                                            {{ item.keperluan }}
                                        </p>
                                    </td>
                                    <td
                                        class="px-5 py-3.5 text-xs text-slate-400"
                                    >
                                        {{ formatDate(item.submittedAt) }}
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <span
                                            class="rounded-full px-2 py-1 text-[10px] font-semibold"
                                            :class="
                                                statusBadgeClass(item.status)
                                            "
                                        >
                                            {{ submissionStatusLabel(item) }}
                                        </span>
                                    </td>
                                    <td class="px-5 py-3.5">
                                        <div
                                            class="flex items-center justify-end gap-1.5"
                                        >
                                            <button
                                                type="button"
                                                title="Preview"
                                                class="grid size-7 place-items-center rounded-lg bg-slate-100 text-slate-500 transition-colors hover:bg-slate-200"
                                                @click="
                                                    openViewer(item, 'preview')
                                                "
                                            >
                                                <Eye class="size-3.5" />
                                            </button>
                                            <button
                                                v-if="item.hasPdf"
                                                type="button"
                                                title="Download PDF"
                                                class="grid size-7 place-items-center rounded-lg bg-blue-50 text-blue-600 transition-colors hover:bg-blue-100"
                                                @click="openViewer(item, 'pdf')"
                                            >
                                                <Download class="size-3.5" />
                                            </button>
                                            <button
                                                v-if="
                                                    item.notes &&
                                                    item.notes.length
                                                "
                                                type="button"
                                                title="Catatan Dekan"
                                                class="grid size-7 place-items-center rounded-lg bg-sky-50 text-sky-600 transition-colors hover:bg-sky-100"
                                                @click="toggleNotes(item.id)"
                                            >
                                                <Info class="size-3.5" />
                                            </button>
                                            <button
                                                v-if="
                                                    item.rejectionReason ||
                                                    item.revisionReason
                                                "
                                                type="button"
                                                title="Catatan"
                                                class="grid size-7 place-items-center rounded-lg bg-red-50 text-red-500 transition-colors hover:bg-red-100"
                                                @click="toggleReason(item.id)"
                                            >
                                                <AlertCircle class="size-3.5" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr
                                    v-if="
                                        expandedNotesId === item.id &&
                                        item.notes?.length
                                    "
                                    class="border-t border-slate-100 bg-sky-50/40"
                                >
                                    <td colspan="5" class="px-5 py-3">
                                        <div class="space-y-2">
                                            <div
                                                v-for="(
                                                    note, nidx
                                                ) in item.notes"
                                                :key="nidx"
                                                class="rounded-xl border border-sky-100 bg-sky-50 px-3 py-2 text-xs"
                                            >
                                                <div
                                                    class="mb-1 flex items-center gap-1.5"
                                                >
                                                    <span
                                                        class="font-semibold text-sky-800"
                                                        >{{
                                                            note.oleh ?? 'Admin'
                                                        }}</span
                                                    >
                                                    <span
                                                        class="text-[10px] text-sky-400"
                                                        >{{
                                                            note.created_at
                                                                ? formatDate(
                                                                      note.created_at,
                                                                  )
                                                                : ''
                                                        }}</span
                                                    >
                                                </div>
                                                <p class="text-sky-700">
                                                    {{ note.catatan }}
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr
                                    v-if="
                                        expandedReasonId === item.id &&
                                        (item.rejectionReason ||
                                            item.revisionReason)
                                    "
                                    class="border-t border-slate-100 bg-red-50/40"
                                >
                                    <td colspan="5" class="px-5 py-3">
                                        <div
                                            class="rounded-xl border border-red-100 bg-red-50 px-3 py-2 text-xs text-red-700"
                                        >
                                            <span class="font-semibold">{{
                                                item.needsRevision
                                                    ? 'Catatan revisi:'
                                                    : 'Alasan penolakan:'
                                            }}</span>
                                            {{
                                                item.needsRevision
                                                    ? item.revisionReason
                                                    : item.rejectionReason
                                            }}
                                        </div>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Kanan: Ajukan + Notifikasi + Info -->
            <div class="space-y-4">
                <!-- Ajukan Surat Baru -->
                <div class="rounded-2xl border border-slate-200 bg-white p-4">
                    <h3
                        class="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900"
                    >
                        <FilePlus2 class="size-4 text-blue-500" /> Ajukan Surat
                    </h3>

                    <!-- Search -->
                    <div class="relative mb-3">
                        <Search
                            class="pointer-events-none absolute top-1/2 left-3 size-3.5 -translate-y-1/2 text-slate-400"
                        />
                        <input
                            v-model="searchQuery"
                            type="text"
                            placeholder="Cari jenis surat..."
                            class="h-9 w-full rounded-lg border border-slate-200 bg-slate-50 py-0 pr-7 pl-8 text-xs text-slate-700 transition outline-none focus:border-blue-400 focus:ring-1 focus:ring-blue-100"
                        />
                        <button
                            v-if="searchQuery"
                            type="button"
                            class="absolute top-1/2 right-2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                            @click="searchQuery = ''"
                        >
                            <X class="size-3" />
                        </button>
                    </div>

                    <!-- Category tabs -->
                    <div
                        v-if="categories.length > 0"
                        class="scrollbar-hide mb-3 flex gap-1.5 overflow-x-auto pb-1"
                    >
                        <button
                            type="button"
                            class="shrink-0 rounded-md px-2 py-1 text-[10px] font-medium transition-colors"
                            :class="
                                activeCategory === null
                                    ? 'bg-blue-500 text-white'
                                    : 'bg-slate-100 text-slate-500 hover:bg-slate-200'
                            "
                            @click="activeCategory = null"
                        >
                            Semua
                        </button>
                        <button
                            v-for="cat in categories"
                            :key="cat.id"
                            type="button"
                            class="shrink-0 rounded-md px-2 py-1 text-[10px] font-medium transition-colors"
                            :class="
                                activeCategory === cat.id
                                    ? 'bg-blue-500 text-white'
                                    : 'bg-slate-100 text-slate-500 hover:bg-slate-200'
                            "
                            @click="
                                activeCategory =
                                    activeCategory === cat.id ? null : cat.id
                            "
                        >
                            {{ cat.nama }}
                        </button>
                    </div>

                    <!-- Card grid -->
                    <div
                        v-if="filteredJenis.length === 0"
                        class="rounded-xl border border-dashed border-slate-200 bg-slate-50/50 px-3 py-3 text-center"
                    >
                        <FileText class="mx-auto mb-1 size-5 text-slate-300" />
                        <p class="text-[10px] text-slate-400">
                            Tidak ada jenis surat
                        </p>
                    </div>
                    <div v-else class="grid gap-2">
                        <button
                            v-for="jenis in filteredJenis"
                            :key="jenis.id"
                            type="button"
                            class="group relative rounded-xl border border-slate-200 bg-white p-3 text-left transition-all hover:border-blue-200 hover:shadow-sm"
                            @click="openForm(jenis)"
                        >
                            <div class="flex items-start gap-2.5">
                                <div
                                    class="grid size-8 shrink-0 place-items-center rounded-lg border border-blue-100 bg-blue-50 text-blue-600"
                                >
                                    <FileText class="size-4" />
                                </div>
                                <div class="min-w-0 flex-1">
                                    <p
                                        class="text-xs font-semibold text-slate-900"
                                    >
                                        {{ jenis.nama }}
                                    </p>
                                    <p
                                        v-if="jenis.deskripsi"
                                        class="mt-0.5 line-clamp-1 text-[10px] text-slate-400"
                                    >
                                        {{ jenis.deskripsi }}
                                    </p>
                                </div>
                                <Plus
                                    class="size-3.5 shrink-0 text-slate-300 transition-colors group-hover:text-blue-500"
                                />
                            </div>
                        </button>
                    </div>
                </div>

                <!-- Notifikasi -->
                <div class="rounded-2xl border border-slate-200 bg-white p-4">
                    <h3
                        class="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900"
                    >
                        <Bell class="size-4 text-blue-500" /> Notifikasi
                    </h3>
                    <div class="space-y-3">
                        <template v-if="latestVisible.length">
                            <div
                                v-for="(item, idx) in latestVisible.slice(0, 3)"
                                :key="idx"
                                class="flex items-start gap-2"
                            >
                                <div
                                    class="mt-1.5 size-1.5 rounded-full"
                                    :class="
                                        item.status === 'rejected_admin' ||
                                        item.status === 'rejected_approver'
                                            ? 'bg-red-500'
                                            : item.status === 'finished'
                                              ? 'bg-green-500'
                                              : 'bg-blue-500'
                                    "
                                />
                                <div>
                                    <p
                                        class="text-xs font-medium text-slate-700"
                                    >
                                        {{ item.jenisSurat }} -
                                        {{ submissionStatusLabel(item) }}
                                    </p>
                                    <p class="text-[10px] text-slate-400">
                                        {{ formatDate(item.submittedAt) }}
                                    </p>
                                </div>
                            </div>
                        </template>
                        <p v-else class="text-xs text-slate-400">
                            Belum ada notifikasi
                        </p>
                    </div>
                </div>

                <!-- Info Akademik -->
                <div
                    v-if="!isRestrictedStaffRole"
                    class="rounded-2xl border border-slate-200 bg-white p-4"
                >
                    <h3
                        class="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900"
                    >
                        <Info class="size-4 text-blue-500" /> Info Akademik
                    </h3>
                    <div class="space-y-2.5 text-xs">
                        <div>
                            <p
                                class="text-[10px] tracking-wider text-slate-400 uppercase"
                            >
                                Program Studi
                            </p>
                            <p class="mt-0.5 font-semibold text-slate-800">
                                Informatika
                            </p>
                        </div>
                        <div>
                            <p
                                class="text-[10px] tracking-wider text-slate-400 uppercase"
                            >
                                Semester
                            </p>
                            <p class="mt-0.5 font-semibold text-slate-800">
                                Genap 2025/2026
                            </p>
                        </div>
                        <div>
                            <p
                                class="text-[10px] tracking-wider text-slate-400 uppercase"
                            >
                                Status
                            </p>
                            <p
                                class="mt-0.5 inline-flex items-center gap-1 font-semibold text-green-600"
                            >
                                <span
                                    class="inline-block size-1.5 rounded-full bg-green-500"
                                />
                                Aktif
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Ajukan Surat -->
        <Transition name="modal">
            <div
                v-if="showFormModal"
                class="fixed inset-0 z-50 flex items-end justify-center bg-black/50 sm:items-center"
                @click.self="closeForm"
            >
                <form
                    class="relative z-10 w-full max-w-lg rounded-t-2xl bg-white pointer-events-auto sm:rounded-2xl"
                    @submit.prevent="doSubmit"
                >
                    <!-- Header -->
                    <div
                        class="flex items-center justify-between border-b border-slate-100 px-5 py-4"
                    >
                        <div>
                            <h3 class="text-base font-semibold text-slate-900">
                                {{ selectedJenis?.nama }}
                            </h3>
                            <p class="text-xs text-slate-400">
                                {{
                                    formStep === 'form'
                                        ? 'Isi data pengajuan'
                                        : 'Tinjau sebelum mengirim'
                                }}
                            </p>
                        </div>
                        <button
                            type="button"
                            class="grid size-8 place-items-center rounded-lg text-slate-400 hover:bg-slate-100"
                            @click="closeForm"
                        >
                            <X class="size-5" />
                        </button>
                    </div>

                    <!-- Step: Form -->
                    <div
                        v-if="formStep === 'form'"
                        class="max-h-[70vh] space-y-4 overflow-y-auto p-5"
                    >
                        <!-- Keperluan -->
                        <div>
                            <label
                                class="mb-1 block text-xs font-medium text-slate-700"
                            >
                                Keperluan <span class="text-red-500">*</span>
                            </label>
                            <textarea
                                v-model="submitForm.keperluan"
                                rows="2"
                                placeholder="Jelaskan keperluan pengajuan surat..."
                                class="w-full resize-none rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400 focus:bg-white"
                            ></textarea>
                            <p
                                v-if="submitForm.errors.keperluan"
                                class="mt-1 text-xs text-red-500"
                            >
                                {{ submitForm.errors.keperluan }}
                            </p>
                        </div>

                        <!-- Tanggal kebutuhan -->
                        <div>
                            <label
                                class="mb-1 block text-xs font-medium text-slate-700"
                            >
                                Tanggal Dibutuhkan
                                <span class="text-red-500">*</span>
                            </label>
                            <input
                                v-model="submitForm.tanggal_kebutuhan"
                                type="date"
                                :min="todayString()"
                                class="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400 focus:bg-white"
                            />
                            <p
                                v-if="submitForm.errors.tanggal_kebutuhan"
                                class="mt-1 text-xs text-red-500"
                            >
                                {{ submitForm.errors.tanggal_kebutuhan }}
                            </p>
                        </div>

                        <!-- Dynamic fields -->
                        <template
                            v-for="field in selectedJenis?.fieldConfig ?? []"
                            :key="field.name"
                        >
                            <div>
                                <label
                                    class="mb-1 block text-xs font-medium text-slate-700"
                                >
                                    {{ field.label }}
                                    <span
                                        v-if="field.required"
                                        class="text-red-500"
                                        >*</span
                                    >
                                </label>

                                <!-- textarea -->
                                <textarea
                                    v-if="field.type === 'textarea'"
                                    v-model="
                                        (
                                            submitForm.field_data as Record<
                                                string,
                                                FieldValue
                                            >
                                        )[field.name] as string
                                    "
                                    :placeholder="field.placeholder"
                                    rows="3"
                                    class="w-full resize-none rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-blue-400"
                                ></textarea>

                                <!-- select -->
                                <select
                                    v-else-if="field.type === 'select'"
                                    v-model="
                                        (
                                            submitForm.field_data as Record<
                                                string,
                                                FieldValue
                                            >
                                        )[field.name]
                                    "
                                    class="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 outline-none focus:border-blue-400"
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

                                <!-- radio -->
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
                                            v-model="
                                                (
                                                    submitForm.field_data as Record<
                                                        string,
                                                        FieldValue
                                                    >
                                                )[field.name]
                                            "
                                            class="text-blue-600"
                                        />
                                        {{ opt.label }}
                                    </label>
                                </div>

                                <!-- checkbox -->
                                <label
                                    v-else-if="field.type === 'checkbox'"
                                    class="flex cursor-pointer items-center gap-2 pt-1"
                                >
                                    <input
                                        type="checkbox"
                                        v-model="
                                            (
                                                submitForm.field_data as Record<
                                                    string,
                                                    FieldValue
                                                >
                                            )[field.name]
                                        "
                                        class="rounded text-blue-600"
                                    />
                                    <span class="text-sm text-slate-700">{{
                                        field.placeholder || field.label
                                    }}</span>
                                </label>

                                <!-- checkbox-group / multiselect -->
                                <div
                                    v-else-if="
                                        [
                                            'checkbox-group',
                                            'multiselect',
                                        ].includes(field.type)
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
                                                (
                                                    submitForm.field_data as Record<
                                                        string,
                                                        FieldValue
                                                    >
                                                )[field.name] as string[]
                                            "
                                            class="rounded text-blue-600"
                                        />
                                        {{ opt.label }}
                                    </label>
                                </div>

                                <!-- default: text / number / date / email -->
                                <input
                                    v-else
                                    v-model="
                                        (
                                            submitForm.field_data as Record<
                                                string,
                                                FieldValue
                                            >
                                        )[field.name] as string
                                    "
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

                        <!-- Lampiran -->
                        <div>
                            <label
                                class="mb-1 block text-xs font-medium text-slate-700"
                            >
                                Lampiran
                                <span
                                    class="text-[10px] font-normal text-slate-400"
                                    >(opsional)</span
                                >
                            </label>
                            <p class="mb-2 text-[10px] text-slate-400">
                                PDF, JPG, PNG, DOC - maks. 4 MB / berkas
                            </p>
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
                                class="flex w-full flex-col items-center justify-center gap-2 rounded-xl border-2 border-dashed border-slate-200 bg-slate-50 py-4 text-slate-500 transition hover:border-blue-300 hover:bg-blue-50/40"
                                @click="triggerFilePick"
                            >
                                <UploadCloud class="size-5 text-slate-400" />
                                <span class="text-xs font-medium"
                                    >Klik untuk pilih berkas</span
                                >
                            </button>
                            <p
                                v-if="submitForm.errors.lampiran"
                                class="mt-1.5 text-xs text-red-500"
                            >
                                {{ submitForm.errors.lampiran }}
                            </p>
                            <ul
                                v-if="submitForm.lampiran.length"
                                class="mt-3 space-y-2"
                            >
                                <li
                                    v-for="(file, i) in submitForm.lampiran"
                                    :key="i"
                                    class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2"
                                >
                                    <Paperclip
                                        class="size-4 shrink-0 text-blue-600"
                                    />
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
                        </div>
                    </div>

                    <!-- Step: Preview -->
                    <div
                        v-else
                        class="max-h-[70vh] space-y-3 overflow-y-auto p-5"
                    >
                        <p class="text-xs text-slate-500">
                            Pastikan data di bawah sudah benar sebelum mengirim.
                        </p>
                        <div
                            class="divide-y divide-slate-100 rounded-xl border border-slate-200"
                        >
                            <div class="flex gap-3 px-4 py-2.5">
                                <span
                                    class="w-32 shrink-0 text-xs text-slate-400"
                                    >Jenis Surat</span
                                >
                                <span
                                    class="text-xs font-medium text-slate-900"
                                    >{{ selectedJenis?.nama }}</span
                                >
                            </div>
                            <div class="flex gap-3 px-4 py-2.5">
                                <span
                                    class="w-32 shrink-0 text-xs text-slate-400"
                                    >Keperluan</span
                                >
                                <span class="text-xs text-slate-900">{{
                                    submitForm.keperluan || '-'
                                }}</span>
                            </div>
                            <div class="flex gap-3 px-4 py-2.5">
                                <span
                                    class="w-32 shrink-0 text-xs text-slate-400"
                                    >Tgl Dibutuhkan</span
                                >
                                <span class="text-xs text-slate-900">{{
                                    submitForm.tanggal_kebutuhan || '-'
                                }}</span>
                            </div>
                            <template
                                v-for="field in selectedJenis?.fieldConfig ??
                                []"
                                :key="field.name"
                            >
                                <div class="flex gap-3 px-4 py-2.5">
                                    <span
                                        class="w-32 shrink-0 text-xs text-slate-400"
                                        >{{ field.label }}</span
                                    >
                                    <span class="text-xs text-slate-900">{{
                                        fieldDisplayValue(field)
                                    }}</span>
                                </div>
                            </template>
                            <div
                                v-if="submitForm.lampiran.length"
                                class="flex gap-3 px-4 py-2.5"
                            >
                                <span
                                    class="w-32 shrink-0 text-xs text-slate-400"
                                    >Lampiran</span
                                >
                                <ul class="flex-1 space-y-1">
                                    <li
                                        v-for="(file, i) in submitForm.lampiran"
                                        :key="i"
                                        class="flex items-center gap-1.5 text-xs text-slate-700"
                                    >
                                        <Paperclip
                                            class="size-3 text-blue-500"
                                        />
                                        {{ file.name }}
                                        <span class="text-slate-400"
                                            >({{ fileSize(file.size) }})</span
                                        >
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Footer tombol -->
                    <div class="flex gap-2 border-t border-slate-100 px-5 py-4">
                        <button
                            v-if="formStep === 'preview'"
                            type="button"
                            class="flex-1 rounded-xl border border-slate-200 py-2.5 text-sm font-medium text-slate-600 transition hover:bg-slate-50"
                            @click="backToForm"
                        >
                            Kembali Edit
                        </button>
                        <button
                            v-else
                            type="button"
                            class="flex-1 rounded-xl border border-slate-200 py-2.5 text-sm font-medium text-slate-600 transition hover:bg-slate-50"
                            @click="closeForm"
                        >
                            Batal
                        </button>

                        <button
                            v-if="formStep === 'form'"
                            type="button"
                            class="flex-1 rounded-xl bg-blue-600 py-2.5 text-sm font-semibold text-white transition hover:bg-blue-700 disabled:opacity-50"
                            :disabled="
                                !submitForm.keperluan ||
                                !submitForm.tanggal_kebutuhan
                            "
                            @click="goToPreview"
                        >
                            Tinjau Pengajuan ?
                        </button>
                        <button
                            v-else
                            type="submit"
                            class="flex-1 rounded-xl bg-blue-600 py-2.5 text-sm font-semibold text-white transition hover:bg-blue-700 disabled:opacity-50"
                            :disabled="submitForm.processing"
                        >
                            {{
                                submitForm.processing
                                    ? 'Mengirim...'
                                    : 'Kirim Pengajuan'
                            }}
                        </button>
                    </div>
                </form>
            </div>
        </Transition>

        <!-- Toast -->
        <Transition name="toast">
            <div
                v-if="toastMessage"
                class="fixed bottom-6 left-1/2 z-50 -translate-x-1/2 rounded-xl border border-blue-200 bg-blue-50 px-5 py-2.5 text-sm font-medium text-blue-800 shadow-lg"
            >
                {{ toastMessage }}
            </div>
        </Transition>

        <!-- Document Viewer Modal -->
        <Transition name="fade">
            <div
                v-if="viewerOpen"
                class="fixed inset-0 z-50 flex flex-col bg-black/70 backdrop-blur-sm"
                @click.self="closeViewer"
            >
                <!-- Mode HTML: header + iframe -->
                <template v-if="viewerMode === 'html'">
                    <div
                        class="flex h-14 shrink-0 items-center justify-between bg-slate-900 px-4"
                    >
                        <div class="flex min-w-0 items-center gap-3">
                            <div
                                class="grid size-8 shrink-0 place-items-center rounded-lg bg-blue-600"
                            >
                                <FileText class="size-4 text-white" />
                            </div>
                            <div class="min-w-0">
                                <p
                                    class="truncate text-sm font-semibold text-white"
                                >
                                    {{ viewerTitle }}
                                </p>
                                <p
                                    v-if="viewerNomor"
                                    class="font-mono text-[10px] text-slate-400"
                                >
                                    {{ viewerNomor }}
                                </p>
                            </div>
                        </div>
                        <div class="flex shrink-0 items-center gap-1">
                            <div class="hidden items-center gap-1 sm:flex">
                                <button
                                    type="button"
                                    class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-slate-700 hover:text-white"
                                    @click="
                                        iframeZoom = Math.max(
                                            50,
                                            iframeZoom - 10,
                                        )
                                    "
                                >
                                    <ZoomOut class="size-4" />
                                </button>
                                <span
                                    class="w-12 text-center text-xs text-slate-300"
                                    >{{ iframeZoom }}%</span
                                >
                                <button
                                    type="button"
                                    class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-slate-700 hover:text-white"
                                    @click="
                                        iframeZoom = Math.min(
                                            200,
                                            iframeZoom + 10,
                                        )
                                    "
                                >
                                    <ZoomIn class="size-4" />
                                </button>
                                <button
                                    type="button"
                                    class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-slate-700 hover:text-white"
                                    @click="iframeZoom = 100"
                                >
                                    <ResetZoom class="size-3.5" />
                                </button>
                            </div>
                            <button
                                type="button"
                                class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-slate-700 hover:text-white"
                                @click="openInNewTab"
                            >
                                <ExternalLink class="size-4" />
                            </button>
                            <button
                                type="button"
                                class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-red-600 hover:text-white"
                                @click="closeViewer"
                            >
                                <X class="size-4" />
                            </button>
                        </div>
                    </div>
                    <div class="relative flex-1 overflow-hidden bg-slate-800">
                        <div
                            v-if="iframeLoad"
                            class="absolute inset-0 z-10 flex items-center justify-center bg-slate-800"
                        >
                            <div class="flex flex-col items-center gap-3">
                                <div
                                    class="size-10 animate-spin rounded-full border-2 border-slate-600 border-t-emerald-500"
                                />
                                <p class="text-sm text-slate-400">
                                    Memuat dokumen...
                                </p>
                            </div>
                        </div>
                        <div
                            class="flex h-full items-start justify-center overflow-auto p-4"
                        >
                            <div
                                class="min-h-full w-full max-w-4xl overflow-hidden rounded-lg shadow-2xl"
                                :style="{
                                    transform: `scale(${iframeZoom / 100})`,
                                    transformOrigin: 'top center',
                                }"
                            >
                                <iframe
                                    v-if="viewerUrl"
                                    :src="viewerUrl"
                                    class="w-full border-0 bg-white transition-opacity"
                                    style="min-height: 80vh"
                                    :class="{ 'opacity-0': iframeLoad }"
                                    @load="iframeLoad = false"
                                    @error="
                                        iframeLoad = false;
                                        iframeError = true;
                                    "
                                />
                            </div>
                        </div>
                    </div>
                </template>

                <!-- Mode PDF: PdfViewer -->
                <template v-else-if="viewerMode === 'pdf' && viewerUrl">
                    <div
                        class="flex h-9 shrink-0 items-center justify-between bg-slate-950 px-4"
                    >
                        <p
                            class="min-w-0 truncate text-xs font-medium text-slate-400"
                        >
                            {{ viewerTitle }}
                        </p>
                        <button
                            type="button"
                            class="flex shrink-0 items-center gap-1.5 rounded-lg px-3 py-1 text-xs text-slate-400 transition-colors hover:bg-slate-800 hover:text-white"
                            @click="closeViewer"
                        >
                            <X class="size-3.5" /> Tutup
                        </button>
                    </div>
                    <div class="flex-1 overflow-hidden">
                        <PdfViewer
                            :src="viewerUrl"
                            :filename="viewerTitle"
                            :show-thumbnails="false"
                            :initial-zoom="100"
                        />
                    </div>
                </template>
            </div>
        </Transition>
    </FastLayout>
</template>

<style scoped>
.modal-enter-active,
.modal-leave-active {
    transition: opacity 0.2s;
}
.modal-enter-from,
.modal-leave-to {
    opacity: 0;
}
.toast-enter-active,
.toast-leave-active {
    transition: all 0.2s;
}
.toast-enter-from,
.toast-leave-to {
    opacity: 0;
    transform: translateX(-50%) translateY(8px);
}
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.15s;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}
.scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>
