<script setup lang="ts">
import FastLayout from '@/layouts/FASt/FastLayout.vue';
import DocumentPreviewModal from '@/components/DocumentPreviewModal.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import {
    FileText,
    Download,
    Eye,
    Search,
    ChevronLeft,
    ChevronRight,
    AlertCircle,
    X,
    CheckCircle2,
    XCircle,
    Clock3,
    FileCheck,
    RotateCcw,
} from 'lucide-vue-next';
type Surat = {
    id: number;
    reference: string;
    jenisSurat: string;
    approvalRole?: {
        id?: number | null;
        nama?: string | null;
        slug?: string | null;
    } | null;
    requiresFinalApproval?: boolean;
    status: string;
    keperluan: string;
    rejectionReason?: string | null;
    revisionReason?: string | null;
    rejectedByRole?: string | null;
    needsRevision?: boolean;
    revisionCount?: number;
    submittedAt?: string | null;
    neededAt?: string | null;
    nomor_surat?: string | null;
    canCancel?: boolean;
    jenisSuratId?: number | null;
    timeline?: {
        action: string;
        label: string;
        description?: string | null;
        created_at?: string | null;
    }[];
};
const props = defineProps<{
    surats: {
        data: Surat[];
        total: number;
        current_page: number;
        last_page: number;
        per_page: number;
    };
    filters: { search?: string; status?: string };
    userRole?: {
        id?: number | null;
        name?: string | null;
        slug?: string | null;
    };
    endpoints?: { basePath: string };
}>();
const basePath = computed(() => props.endpoints?.basePath ?? '/mahasiswa');
const search = ref(props.filters.search ?? '');
const status = ref(props.filters.status ?? '');
const expandedReasonId = ref<number | null>(null);
const cancelConfirmId = ref<number | null>(null);
// ── [BARU] PDF Viewer state ─────────────────────────────────────────────────
const viewerOpen = ref(false);
const viewerUrl = ref<string | null>(null);
const viewerTitle = ref('');
const viewerType = ref<'html' | 'pdf'>('html');
const viewerStatus = ref('');
const viewerNomor = ref<string | null>(null);
function openViewer(item: Surat, mode: 'preview' | 'download') {
    if (mode === 'preview') {
        viewerUrl.value = `/documents/surat/${item.id}/generated-document`;
        viewerTitle.value = `Preview — ${item.jenisSurat}`;
        viewerType.value = 'html';
    } else {
        viewerUrl.value = `/documents/surat/${item.id}/pdf`;
        viewerTitle.value = `${item.jenisSurat} — ${item.reference}`;
        viewerType.value = 'pdf';
    }
    viewerStatus.value = item.status;
    viewerNomor.value = item.nomor_surat ?? item.reference;
    viewerOpen.value = true;
}
function closeViewer() {
    viewerOpen.value = false;
    setTimeout(() => {
        viewerUrl.value = null;
    }, 200);
}
// ── [END BARU] ──────────────────────────────────────────────────────────────
function statusLabel(status: string) {
    const map: Record<string, string> = {
        pending: 'Menunggu Validasi',
        validated_admin: 'Diteruskan ke Approver',
        revision_requested: 'Sedang Direvisi Admin',
        approved_kaprodi: 'Disetujui Kaprodi',
        approved_dekan: 'Disetujui Dekan',
        finished: 'Selesai',
        rejected_admin: 'Ditolak Admin',
        rejected_approver: 'Ditolak Pimpinan',
        cancelled: 'Dibatalkan',
    };
    return map[status] ?? 'Diproses';
}
function submissionStatusLabel(item: Surat) {
    if (item.status === 'revision_requested' && item.needsRevision) {
        return 'Perlu Revisi';
    }
    return statusLabel(item.status);
}
function statusBadgeClass(status: string) {
    const map: Record<string, string> = {
        pending: 'bg-amber-50 text-amber-700',
        validated_admin: 'bg-slate-100 text-slate-700',
        revision_requested: 'bg-amber-50 text-amber-700',
        approved_kaprodi: 'bg-emerald-50 text-emerald-700',
        approved_dekan: 'bg-emerald-50 text-emerald-700',
        finished: 'bg-emerald-50 text-emerald-700',
        rejected_admin: 'bg-red-50 text-red-700',
        rejected_approver: 'bg-red-50 text-red-700',
        cancelled: 'bg-slate-100 text-slate-600',
    };
    return map[status] ?? 'bg-slate-100 text-slate-600';
}
function statusIcon(s: string) {
    if (s === 'finished') return FileCheck;
    if (
        s === 'rejected_admin' ||
        s === 'rejected_approver' ||
        s === 'cancelled'
    )
        return XCircle;
    if (s.startsWith('approved')) return CheckCircle2;
    if (s === 'validated_admin') return FileCheck;
    return Clock3;
}
function statusColor(s: string) {
    if (s === 'finished')
        return {
            bg: 'bg-emerald-50',
            border: 'border-emerald-200',
            text: 'text-emerald-600',
            line: 'bg-emerald-300',
        };
    if (
        s === 'rejected_admin' ||
        s === 'rejected_approver' ||
        s === 'cancelled'
    )
        return {
            bg: 'bg-red-50',
            border: 'border-red-200',
            text: 'text-red-600',
            line: 'bg-red-300',
        };
    if (s.startsWith('approved'))
        return {
            bg: 'bg-emerald-50',
            border: 'border-emerald-200',
            text: 'text-emerald-600',
            line: 'bg-emerald-300',
        };
    if (s === 'validated_admin')
        return {
            bg: 'bg-slate-100',
            border: 'border-slate-200',
            text: 'text-slate-600',
            line: 'bg-slate-300',
        };
    return {
        bg: 'bg-amber-50',
        border: 'border-amber-200',
        text: 'text-amber-600',
        line: 'bg-amber-300',
    };
}
function statusClass(s: string) {
    if (s === 'finished') return 'bg-emerald-50 text-emerald-700';
    if (
        s === 'rejected_admin' ||
        s === 'rejected_approver' ||
        s === 'cancelled'
    )
        return 'bg-red-50 text-red-700';
    if (s.startsWith('approved')) return 'bg-emerald-50 text-emerald-700';
    if (s === 'validated_admin') return 'bg-slate-100 text-slate-700';
    return 'bg-amber-50 text-amber-700';
}
function formatDate(date?: string | null) {
    if (!date) return '-';
    return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    }).format(new Date(date));
}
function applyFilter() {
    router.get(
        `${basePath.value}/history`,
        { search: search.value, status: status.value },
        { preserveState: true },
    );
}
function detailHref(item: Surat) {
    return `${basePath.value}/history/${item.id}`;
}
function toggleReason(id: number) {
    expandedReasonId.value = expandedReasonId.value === id ? null : id;
}
function confirmCancel(id: number) {
    cancelConfirmId.value = id;
}
function cancelSurat(id: number) {
    router.post(
        `${basePath.value}/surat/${id}/cancel`,
        {},
        {
            preserveScroll: true,
            onSuccess: () => {
                cancelConfirmId.value = null;
            },
        },
    );
}
function rejectionDetailLabel(item: Surat) {
    if (item.needsRevision) {
        return `Catatan revisi ${item.rejectedByRole === 'dekan' ? 'Dekan' : 'Kaprodi'}`;
    }
    return 'Alasan penolakan';
}
function goToPage(page: number) {
    router.get(
        `${basePath.value}/history`,
        { search: search.value, status: status.value, page },
        { preserveState: true },
    );
}
</script>
<template>
    <FastLayout
        title="Riwayat Surat"
        subtitle="Semua pengajuan surat Anda"
        active-menu="history"
        :breadcrumbs="[
            { label: 'Dashboard', href: `${basePath}/dashboard` },
            { label: 'Riwayat Surat' },
        ]"
    >
        <Head title="Riwayat Surat — FAST" />
        <section class="mb-5 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div class="flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between">
                <div class="max-w-2xl">
                    <p class="text-[10px] font-semibold tracking-[0.2em] text-slate-400 uppercase">
                        Filter surat
                    </p>
                    <h3 class="mt-1 text-lg font-semibold text-slate-900">
                        Temukan riwayat pengajuan dengan cepat
                    </h3>
                    <p class="mt-1 text-sm text-slate-500">
                        Gunakan pencarian untuk nama surat atau keperluan, lalu pilih status yang paling relevan.
                    </p>
                </div>
            </div>

            <div class="mt-4 space-y-3">
                <div class="relative">
                    <Search
                        class="pointer-events-none absolute top-1/2 left-3.5 size-4 -translate-y-1/2 text-slate-400"
                    />
                    <input
                        v-model="search"
                        type="text"
                        placeholder="Cari riwayat surat, misalnya observasi atau cuti..."
                        class="h-11 w-full rounded-2xl border border-slate-200 bg-slate-50 py-0 pr-10 pl-10 text-sm text-slate-800 outline-none transition focus:border-blue-400 focus:bg-white focus:ring-2 focus:ring-blue-100"
                        @keyup.enter="applyFilter"
                    />
                    <button
                        v-if="search"
                        type="button"
                        class="absolute top-1/2 right-3 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                        @click="
                            search = '';
                            applyFilter();
                        "
                    >
                        <X class="size-4" />
                    </button>
                </div>

                <div class="flex flex-wrap gap-2">
                    <button
                        type="button"
                        class="inline-flex items-center rounded-full border px-3 py-1.5 text-xs font-semibold transition duration-200"
                        :class="
                            !status
                                ? 'border-blue-200 bg-blue-50 text-blue-700 shadow-sm'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-blue-200 hover:text-blue-700'
                        "
                        @click="
                            status = '';
                            applyFilter();
                        "
                    >
                        Semua
                    </button>
                    <button
                        type="button"
                        class="inline-flex items-center rounded-full border px-3 py-1.5 text-xs font-semibold transition duration-200"
                        :class="
                            status === 'pending'
                                ? 'border-blue-200 bg-blue-50 text-blue-700 shadow-sm'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-blue-200 hover:text-blue-700'
                        "
                        @click="
                            status = 'pending';
                            applyFilter();
                        "
                    >
                        Pending
                    </button>
                    <button
                        type="button"
                        class="inline-flex items-center rounded-full border px-3 py-1.5 text-xs font-semibold transition duration-200"
                        :class="
                            status === 'finished'
                                ? 'border-blue-200 bg-blue-50 text-blue-700 shadow-sm'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-blue-200 hover:text-blue-700'
                        "
                        @click="
                            status = 'finished';
                            applyFilter();
                        "
                    >
                        Selesai
                    </button>
                    <button
                        type="button"
                        class="inline-flex items-center rounded-full border px-3 py-1.5 text-xs font-semibold transition duration-200"
                        :class="
                            status === 'rejected_admin'
                                ? 'border-blue-200 bg-blue-50 text-blue-700 shadow-sm'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-blue-200 hover:text-blue-700'
                        "
                        @click="
                            status = 'rejected_admin';
                            applyFilter();
                        "
                    >
                        Ditolak Admin
                    </button>
                    <button
                        type="button"
                        class="inline-flex items-center rounded-full border px-3 py-1.5 text-xs font-semibold transition duration-200"
                        :class="
                            status === 'rejected_approver'
                                ? 'border-blue-200 bg-blue-50 text-blue-700 shadow-sm'
                                : 'border-slate-200 bg-white text-slate-600 hover:border-blue-200 hover:text-blue-700'
                        "
                        @click="
                            status = 'rejected_approver';
                            applyFilter();
                        "
                    >
                        Ditolak Pimpinan
                    </button>
                </div>

            </div>
        </section>
        <!-- Timeline cards -->
        <div class="relative pl-8">
            <div
                class="absolute top-3 bottom-3 left-[19px] w-px bg-slate-200"
            />
            <div
                v-if="surats.data.length === 0"
                class="rounded-3xl border border-dashed border-slate-200 bg-white px-6 py-14 text-center shadow-sm"
            >
                <div class="mx-auto grid size-16 place-items-center rounded-2xl bg-slate-100 text-slate-300">
                    <Calendar class="size-8" />
                </div>
                <p class="mt-4 text-base font-semibold text-slate-700">
                    Belum ada riwayat pengajuan
                </p>
                <p class="mt-1 text-sm text-slate-400">
                    Pengajuan baru akan tampil setelah surat dibuat.
                </p>
            </div>
            <div
                v-for="(item, idx) in surats.data"
                :key="item.id"
                class="relative mb-4"
            >
                <!-- Timeline dot -->
                <div
                    class="absolute top-0 -left-8 z-10 grid size-10 place-items-center rounded-full border-2 bg-white"
                    :class="statusColor(item.status).border"
                >
                    <component
                        :is="statusIcon(item.status)"
                        :class="['size-5', statusColor(item.status).text]"
                    />
                </div>
                <!-- Card -->
                <div
                    class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:shadow-md"
                    :class="[
                        item.status === 'finished'
                            ? 'hover:border-blue-300'
                            : item.status === 'rejected_admin' ||
                                item.status === 'rejected_approver' ||
                                item.status === 'cancelled'
                              ? 'hover:border-red-300'
                              : item.status.startsWith('approved')
                                ? 'hover:border-sky-300'
                                : 'hover:border-amber-300',
                    ]"
                >
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                        <div class="min-w-0 flex-1">
                            <div class="flex flex-wrap items-center gap-2">
                                <p class="text-base font-semibold text-slate-900">
                                    {{ item.jenisSurat }}
                                </p>
                                <span
                                    class="rounded-full px-2.5 py-1 text-[10px] font-semibold"
                                    :class="statusClass(item.status)"
                                >
                                    {{ submissionStatusLabel(item) }}
                                </span>
                            </div>
                            <p
                                v-if="item.reference"
                                class="mt-1 font-mono text-[11px] text-slate-400"
                            >
                                {{ item.reference }}
                            </p>
                            <p
                                class="mt-3 text-sm leading-relaxed text-slate-600"
                            >
                                {{ item.keperluan }}
                            </p>
                            <div
                                class="mt-3 flex flex-wrap items-center gap-3 text-[11px] text-slate-400"
                            >
                                <span class="flex items-center gap-1">
                                    <Calendar class="size-3.5" />
                                    {{ formatDate(item.submittedAt) }}
                                </span>
                                <span
                                    v-if="item.neededAt"
                                    class="flex items-center gap-1"
                                >
                                    <Clock3 class="size-3.5" /> Butuh:
                                    {{ formatDate(item.neededAt) }}
                                </span>
                            </div>
                            <!-- Expanded reason -->
                            <div
                                v-if="
                                    expandedReasonId === item.id &&
                                    (item.rejectionReason ||
                                        item.revisionReason)
                                "
                                class="mt-3 rounded-xl border border-red-100 bg-red-50 px-3 py-2 text-xs text-red-700"
                            >
                                <span class="font-semibold"
                                    >{{ rejectionDetailLabel(item) }}:</span
                                >
                                {{
                                    item.needsRevision
                                        ? item.revisionReason
                                        : item.rejectionReason
                                }}
                            </div>
                            <!-- Cancel confirm -->
                            <div
                                v-if="cancelConfirmId === item.id"
                                class="mt-3 flex items-center gap-2 rounded-xl border border-amber-200 bg-amber-50 px-3 py-2"
                            >
                                <p class="text-xs font-medium text-amber-800">
                                    Batalkan pengajuan?
                                </p>
                                <button
                                    type="button"
                                    class="rounded bg-red-600 px-2 py-1 text-[10px] font-semibold text-white hover:bg-red-700"
                                    @click="cancelSurat(item.id)"
                                >
                                    Ya
                                </button>
                                <button
                                    type="button"
                                    class="rounded border border-slate-200 bg-white px-2 py-1 text-[10px] text-slate-600 hover:bg-slate-50"
                                    @click="cancelConfirmId = null"
                                >
                                    Tidak
                                </button>
                            </div>
                        </div>
                        <!-- Actions -->
                        <div class="flex shrink-0 flex-wrap items-start gap-2 lg:justify-end">
                            <Link
                                :href="detailHref(item)"
                                title="Detail Surat"
                                class="inline-flex items-center gap-1.5 rounded-full border border-slate-200 px-3 py-1.5 text-[10px] font-medium text-slate-600 transition-colors hover:border-blue-200 hover:bg-blue-50 hover:text-blue-600"
                            >
                                <FileText class="size-3" /> Detail Surat
                            </Link>
                            <button
                                v-if="item.status === 'finished'"
                                type="button"
                                title="Download PDF"
                                class="flex items-center gap-1.5 rounded-full bg-blue-600 px-3 py-1.5 text-[10px] font-medium text-white transition-colors hover:bg-blue-700"
                                @click="openViewer(item, 'download')"
                            >
                                <Download class="size-3" /> PDF
                            </button>
                            <button
                                v-if="
                                    [
                                        'revision_requested',
                                        'rejected_admin',
                                        'rejected_approver',
                                    ].includes(item.status) &&
                                    (item.rejectionReason ||
                                        item.revisionReason)
                                "
                                type="button"
                                title="Catatan"
                                class="flex items-center gap-1.5 rounded-full border border-red-200 bg-red-50 px-3 py-1.5 text-[10px] font-medium text-red-600 transition-colors hover:bg-red-100"
                                @click="toggleReason(item.id)"
                            >
                                <AlertCircle class="size-3" /> Catatan
                            </button>
                            <button
                                v-if="item.status === 'pending'"
                                type="button"
                                title="Batalkan"
                                class="flex items-center gap-1 rounded-full border border-red-200 bg-red-50 px-2.5 py-1.5 text-xs font-medium text-red-600 transition hover:bg-red-100"
                                @click="confirmCancel(item.id)"
                            >
                                <X class="size-3.5" /> Batal
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Pagination -->
        <div
            v-if="surats.last_page > 1"
            class="mt-5 flex flex-wrap items-center gap-1.5 pl-8"
        >
            <button
                type="button"
                class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                :class="
                    surats.current_page === 1
                        ? 'pointer-events-none bg-slate-100 text-slate-600 opacity-40'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                "
                :disabled="surats.current_page === 1"
                @click="goToPage(surats.current_page - 1)"
            >
                <ChevronLeft class="size-3.5" />
            </button>
            <button
                v-for="p in surats.last_page"
                :key="p"
                type="button"
                class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                :class="
                    p === surats.current_page
                        ? 'bg-blue-600 text-white'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                "
                @click="goToPage(p)"
            >
                {{ p }}
            </button>
            <button
                type="button"
                class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                :class="
                    surats.current_page === surats.last_page
                        ? 'pointer-events-none bg-slate-100 text-slate-600 opacity-40'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                "
                :disabled="surats.current_page === surats.last_page"
                @click="goToPage(surats.current_page + 1)"
            >
                <ChevronRight class="size-3.5" />
            </button>
        </div>
        <DocumentPreviewModal
            :open="viewerOpen"
            :mode="viewerType"
            :title="viewerTitle"
            :url="viewerUrl"
            :show-html-zoom-controls="true"
            :show-thumbnails="false"
            :initial-zoom="100"
            @close="closeViewer"
        />
    </FastLayout>
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
