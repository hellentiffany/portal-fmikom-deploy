<script setup lang="ts">
import AdminLayout from '@/layouts/FASt/AdminLayout.vue';
import PdfViewer from '@/components/PdfViewer.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import {
    AlertCircle,
    ArrowLeft,
    CheckCircle,
    Clock,
    Copy,
    Download,
    Eye,
    FileEdit,
    FileText,
    QrCode,
    ShieldCheck,
    X,
} from 'lucide-vue-next';

type Lampiran = { id: number; name: string; url: string; type: string };

type TimelineItem = {
    id: number;
    label: string;
    note?: string | null;
    description?: string | null;
    acted_at?: string | null;
    created_at?: string | null;
    status?: string | null;
    action?: string | null;
    actor?: string | null;
    role?: string | null;
};

type Surat = {
    id: number;
    nomor_surat?: string | null;
    pemohon: { name: string; nim?: string | null };
    jenis_surat: string;
    keperluan: string;
    isi_surat: Record<string, any>;
    lampiran: Lampiran[];
    tanggal_pengajuan: string | null;
    status: string;
    latest_rejection?: {
        role?: string | null;
        label: string;
        type: 'revision' | 'final_reject';
        note?: string | null;
        acted_at?: string | null;
    } | null;
    approval_timeline?: TimelineItem[];
    history_timeline?: TimelineItem[];
    can_approve: boolean;
    can_edit: boolean;
    previewTemplateUrl: string | null;
    generatedDocumentUrl: string | null;
};

const props = defineProps<{ id: number } & Surat>();

const viewerOpen = ref(false);
const viewerUrl = ref<string | null>(null);
const viewerTitle = ref('');
const viewerType = ref<'html' | 'pdf'>('html');
const copiedNumber = ref(false);
const expandedTimelineNoteId = ref<number | null>(null);

const isFinished = computed(() => props.status === 'finished');
const documentTitle = computed(() =>
    props.nomor_surat
        ? `${props.jenis_surat} - ${props.nomor_surat}`
        : props.jenis_surat,
);

const completedAt = computed(() => {
    if (!isFinished.value) return null;

    const historyLatest = props.history_timeline?.[0]?.created_at ?? null;
    const approvalLatest =
        props.approval_timeline?.[props.approval_timeline.length - 1]
            ?.acted_at ?? null;

    return historyLatest ?? approvalLatest ?? props.tanggal_pengajuan;
});

const statusLabel: Record<string, string> = {
    pending: 'Menunggu Validasi',
    revision_requested: 'Menunggu Revisi Admin',
    validated_admin: 'Sudah Divalidasi Admin',
    approved_kaprodi: 'Disetujui Kaprodi',
    approved_dekan: 'Disetujui Dekan',
    finished: 'Selesai',
    rejected_admin: 'Ditolak Admin',
    rejected_approver: props.latest_rejection?.label ?? 'Ditolak Pimpinan',
};

const statusColor: Record<string, string> = {
    pending: 'bg-amber-50 text-amber-700 border-amber-200',
    revision_requested: 'bg-amber-50 text-amber-700 border-amber-200',
    validated_admin: 'bg-blue-50 text-blue-700 border-blue-200',
    approved_kaprodi: 'bg-blue-50 text-blue-700 border-blue-200',
    approved_dekan: 'bg-blue-50 text-blue-700 border-blue-200',
    finished: 'bg-blue-100 text-blue-800 border-blue-300',
    rejected_admin: 'bg-red-50 text-red-700 border-red-200',
    rejected_approver: 'bg-red-50 text-red-700 border-red-200',
};

const processTimeline = computed(() => {
    const approval = props.approval_timeline ?? [];
    if (approval.length > 0) {
        return approval.map((entry) => ({
            id: entry.id,
            label: entry.label,
            note: entry.note ?? null,
            timestamp: entry.acted_at ?? null,
        }));
    }

    return (props.history_timeline ?? []).map((entry) => ({
        id: entry.id,
        label: entry.label,
        note: entry.description ?? null,
        timestamp: entry.created_at ?? null,
    }));
});

function formatDisplayValue(value: unknown): string {
    if (value === null || value === undefined || value === '') return '-';
    if (Array.isArray(value)) {
        const items = value
            .map((item) => formatDisplayValue(item))
            .filter((item) => item !== '-');
        return items.length > 0 ? items.join(', ') : '-';
    }
    if (typeof value === 'object') {
        const candidate = value as Record<string, unknown>;
        return (
            String(candidate.name ?? candidate.label ?? candidate.value ?? '') ||
            '-'
        );
    }
    return String(value);
}

function formatDate(iso: string | null): string {
    if (!iso) return '-';

    return (
        new Date(iso).toLocaleString('id-ID', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
        }) + ' WIB'
    );
}

function formatDateOnly(iso: string | null): string {
    if (!iso) return '-';

    return new Date(iso).toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
    });
}

function timelineBadgeClass(status?: string | null, action?: string | null): string {
    if (
        status === 'rejected_final' ||
        status === 'revision_requested' ||
        action === 'rejected' ||
        action === 'revised'
    ) {
        return 'border-red-200 bg-red-50 text-red-700';
    }

    if (status === 'approved' || action === 'approved' || action === 'validated') {
        return 'border-blue-200 bg-blue-50 text-blue-700';
    }

    if (status === 'note') {
        return 'border-indigo-200 bg-indigo-50 text-indigo-700';
    }

    return 'border-slate-200 bg-slate-50 text-slate-700';
}

function openPreviewDocument() {
    const sourceUrl = props.generatedDocumentUrl ?? props.previewTemplateUrl;
    if (!sourceUrl) return;

    const isPdfDocument = sourceUrl.endsWith('/pdf');
    viewerUrl.value = sourceUrl;
    viewerTitle.value = documentTitle.value;
    viewerType.value = isPdfDocument ? 'pdf' : 'html';
    viewerOpen.value = true;
}

function openDownloadPdf() {
    viewerUrl.value = `/admin/surat/${props.id}/pdf`;
    viewerTitle.value = documentTitle.value;
    viewerType.value = 'pdf';
    viewerOpen.value = true;
}

function goBack() {
    if (window.history.length > 1) {
        window.history.back();
        return;
    }

    router.visit('/admin/archive');
}

function closeViewer() {
    viewerOpen.value = false;
    setTimeout(() => {
        viewerUrl.value = null;
    }, 200);
}

async function copyNomorSurat() {
    if (!props.nomor_surat) return;

    try {
        await navigator.clipboard.writeText(props.nomor_surat);
        copiedNumber.value = true;
        window.setTimeout(() => {
            copiedNumber.value = false;
        }, 1600);
    } catch {
        copiedNumber.value = false;
    }
}

function toggleTimelineNote(id: number) {
    expandedTimelineNoteId.value =
        expandedTimelineNoteId.value === id ? null : id;
}
</script>

<template>
    <AdminLayout
        title="Detail Surat"
        :subtitle="jenis_surat"
        active-menu="letters"
        :breadcrumbs="[
            { label: 'Arsip', href: '/admin/archive' },
            { label: 'Detail Surat' },
        ]"
    >
        <Head :title="`Detail Surat - ${jenis_surat}`" />

        <div class="mx-auto max-w-6xl space-y-5">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <button
                    type="button"
                    class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm transition hover:border-slate-300 hover:bg-slate-50"
                    @click="goBack"
                >
                    <ArrowLeft class="size-4" />
                    Kembali
                </button>
            </div>

            <section class="grid gap-4 lg:grid-cols-[minmax(0,1.55fr)_minmax(320px,0.9fr)]">
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_1px_2px_rgba(15,23,42,0.04)]">
                    <div class="mb-4 flex items-center gap-3">
                        <div class="grid size-10 place-items-center rounded-2xl bg-blue-50 text-blue-600 ring-1 ring-blue-100">
                            <FileText class="size-5" />
                        </div>
                        <div>
                            <h2 class="text-base font-bold text-slate-900">
                                Data Surat
                            </h2>
                            <p class="text-sm text-slate-500">
                                Detail isi dan informasi yang tercantum pada surat.
                            </p>
                        </div>
                    </div>

                    <div class="mt-2 divide-y divide-slate-100 rounded-2xl border border-slate-200 bg-white">
                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">Nama</p>
                            <p class="min-w-0 break-words font-medium leading-6 text-slate-900">
                                {{ pemohon?.name || '-' }}
                            </p>
                        </div>

                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">NIM / NIP</p>
                            <p class="min-w-0 break-words font-mono font-medium leading-6 text-slate-900">
                                {{ pemohon?.nim || '-' }}
                            </p>
                        </div>

                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">Jenis Surat</p>
                            <p class="min-w-0 break-words font-medium leading-6 text-slate-900">
                                {{ jenis_surat || '-' }}
                            </p>
                        </div>

                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">Tanggal Pengajuan</p>
                            <p class="min-w-0 break-words font-medium leading-6 text-slate-900">
                                {{ formatDate(tanggal_pengajuan) }}
                            </p>
                        </div>

                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">Nomor Surat</p>
                            <div class="min-w-0">
                                <button
                                    v-if="nomor_surat"
                                    type="button"
                                    class="inline-flex max-w-full items-center gap-2 rounded-lg border border-slate-200 bg-slate-50 px-3 py-1.5 text-left text-sm text-slate-700 transition hover:border-slate-300 hover:bg-slate-100"
                                    @click="copyNomorSurat"
                                >
                                    <span class="min-w-0 break-words font-mono">
                                        {{ nomor_surat }}
                                    </span>
                                    <Copy class="size-3.5 shrink-0 text-slate-400" />
                                </button>
                                <p v-else class="font-medium leading-6 text-slate-900">
                                    -
                                </p>
                                <p v-if="copiedNumber" class="mt-1 text-xs text-emerald-600">
                                    Nomor surat disalin.
                                </p>
                            </div>
                        </div>

                        <div class="grid gap-2 px-4 py-3 text-sm md:grid-cols-[180px_minmax(0,1fr)] md:gap-4">
                            <p class="text-slate-500">Keperluan</p>
                            <p class="min-w-0 break-words font-medium leading-6 text-slate-900">
                                {{ keperluan || '-' }}
                            </p>
                        </div>
                    </div>
                </div>

                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_1px_2px_rgba(15,23,42,0.04)]">
                    <div class="mb-4 flex items-center gap-3">
                        <div class="grid size-10 place-items-center rounded-2xl bg-blue-50 text-blue-600 ring-1 ring-blue-100">
                            <Download class="size-5" />
                        </div>
                        <div>
                            <h2 class="text-base font-bold text-slate-900">
                                Dokumen
                            </h2>
                            <p class="text-sm text-slate-500">
                                Akses preview dan unduhan dokumen surat.
                            </p>
                        </div>
                    </div>

                    <div
                        class="rounded-2xl border px-4 py-4"
                        :class="
                                isFinished
                                    ? 'border-blue-200 bg-blue-50'
                                : 'border-amber-200 bg-amber-50'
                        "
                    >
                        <div class="flex items-start gap-3">
                            <QrCode
                                class="mt-0.5 size-5 shrink-0"
                                :class="
                                        isFinished
                                            ? 'text-blue-600'
                                            : 'text-amber-600'
                                "
                            />
                            <div>
                                <p
                                    class="text-sm font-semibold"
                                    :class="
                                            isFinished
                                                ? 'text-blue-800'
                                                : 'text-amber-800'
                                    "
                                >
                                    {{
                                        isFinished
                                            ? 'QR Code Aktif'
                                            : 'QR Code Belum Aktif'
                                    }}
                                </p>
                                <p
                                    class="mt-1 text-xs leading-5"
                                    :class="
                                            isFinished
                                                ? 'text-blue-700'
                                                : 'text-amber-700'
                                    "
                                >
                                    {{
                                        isFinished
                                            ? 'Surat sudah divalidasi. QR Code dapat dipindai untuk verifikasi.'
                                            : 'QR Code akan aktif setelah surat selesai divalidasi dan disetujui.'
                                    }}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div v-if="can_edit" class="mt-4">
                        <Link
                            :href="`/admin/surat/${id}/edit`"
                            class="inline-flex w-full items-center justify-center gap-2 rounded-xl border border-blue-200 bg-blue-50 px-4 py-2.5 text-sm font-semibold text-blue-700 transition hover:bg-blue-100"
                        >
                            <FileEdit class="size-4" />
                            Edit & Teruskan
                        </Link>
                    </div>

                    <div class="mt-4 space-y-3">
                        <button
                            v-if="previewTemplateUrl || generatedDocumentUrl"
                            type="button"
                            class="inline-flex w-full items-center justify-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-semibold text-slate-700 transition hover:border-slate-300 hover:bg-slate-50"
                            @click="openPreviewDocument"
                        >
                            <Eye class="size-4" />
                            Preview Dokumen
                        </button>

                        <button
                            v-if="isFinished"
                            type="button"
                            class="inline-flex w-full items-center justify-center gap-2 rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-blue-700"
                            @click="openDownloadPdf"
                        >
                            <Download class="size-4" />
                            Download PDF
                        </button>

                        <div
                            v-else
                            class="flex items-center gap-2 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-700"
                        >
                            <Clock class="size-4 shrink-0" />
                            Dokumen belum tersedia - surat belum selesai diproses.
                        </div>
                    </div>
                </div>
            </section>

            <section class="rounded-3xl border border-slate-200 bg-white p-6 shadow-[0_1px_2px_rgba(15,23,42,0.04)]">
                <div class="mb-5 flex items-center gap-3">
                    <div class="grid size-10 place-items-center rounded-2xl bg-blue-50 text-blue-600 ring-1 ring-blue-100">
                        <ShieldCheck class="size-5" />
                    </div>
                    <div>
                        <h2 class="text-base font-bold text-slate-900">
                            Riwayat Persetujuan
                        </h2>
                        <p class="text-sm text-slate-500">
                            Alur proses surat dari validasi sampai selesai.
                        </p>
                    </div>
                </div>

                <div v-if="processTimeline.length > 0" class="space-y-4">
                    <div
                        v-for="(entry, index) in processTimeline"
                        :key="entry.id"
                        class="grid gap-4 md:grid-cols-[24px_minmax(0,1fr)_190px] md:items-start"
                    >
                        <div class="relative flex justify-center">
                            <span
                                v-if="index !== processTimeline.length - 1"
                                class="absolute top-7 h-full w-px bg-blue-200"
                            />
                            <span
                                class="relative z-10 mt-1 grid size-6 place-items-center rounded-full bg-blue-600 text-white shadow-sm"
                            >
                                <CheckCircle class="size-3.5" />
                            </span>
                        </div>

                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <div class="flex items-start justify-between gap-3">
                                <p class="text-sm font-semibold text-slate-900">
                                    {{ entry.label }}
                                </p>
                                <button
                                    v-if="entry.note"
                                    type="button"
                                    class="inline-flex shrink-0 items-center gap-1 rounded-full border border-red-200 bg-red-50 px-2 py-1 text-xs font-semibold text-red-600 transition hover:border-red-300 hover:bg-red-100"
                                    :aria-expanded="expandedTimelineNoteId === entry.id"
                                    :aria-controls="`timeline-note-${entry.id}`"
                                    @click="toggleTimelineNote(entry.id)"
                                >
                                    <AlertCircle class="size-3.5" />
                                    Catatan
                                </button>
                            </div>
                            <Transition name="fade">
                                <div
                                    v-if="entry.note && expandedTimelineNoteId === entry.id"
                                    :id="`timeline-note-${entry.id}`"
                                    class="mt-3 rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700"
                                >
                                    {{ entry.note }}
                                </div>
                            </Transition>
                        </div>

                        <div class="pt-1 text-xs text-slate-500 md:text-right">
                            {{ formatDate(entry.timestamp) }}
                        </div>
                    </div>
                </div>

                <div v-else class="rounded-2xl border border-dashed border-slate-200 bg-slate-50 px-4 py-6 text-sm text-slate-500">
                    Riwayat belum tersedia.
                </div>
            </section>
        </div>
        <Transition name="fade">
            <div
                v-if="viewerOpen"
                class="fixed inset-0 z-50 flex flex-col bg-black/70 backdrop-blur-sm"
                @click.self="closeViewer"
            >
                <template v-if="viewerType === 'html'">
                    <div
                        class="flex h-12 shrink-0 items-center justify-between bg-slate-900 px-4"
                    >
                        <p class="min-w-0 truncate text-sm font-medium text-white">
                            {{ viewerTitle }}
                        </p>
                        <button
                            type="button"
                            class="grid size-8 place-items-center rounded-lg text-slate-400 transition-colors hover:bg-red-600 hover:text-white"
                            @click="closeViewer"
                        >
                            <X class="size-4" />
                        </button>
                    </div>
                    <div class="flex-1 overflow-auto bg-slate-800 p-4">
                        <iframe
                            v-if="viewerUrl"
                            :src="viewerUrl"
                            class="w-full rounded-lg border-0 bg-white shadow-2xl"
                            style="min-height: 80vh"
                        />
                    </div>
                </template>

                <template v-else-if="viewerType === 'pdf' && viewerUrl">
                    <div
                        class="flex h-9 shrink-0 items-center justify-between bg-slate-950 px-4"
                    >
                        <p class="min-w-0 truncate text-xs font-medium text-slate-400">
                            {{ viewerTitle }}
                        </p>
                        <button
                            type="button"
                            class="flex shrink-0 items-center gap-1.5 rounded-lg px-3 py-1 text-xs text-slate-400 transition-colors hover:bg-slate-800 hover:text-white"
                            @click="closeViewer"
                        >
                            <X class="size-3.5" />
                            Tutup
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
    </AdminLayout>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
