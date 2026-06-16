<script setup lang="ts">
// File: resources/js/pages/admin/dashboard/Index.vue
import AdminLayout from '@/layouts/FASt/AdminLayout.vue';
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import {
    Eye,
    CheckCircle2,
    XCircle,
    Clock3,
    FileText,
    AlertTriangle,
    X,
    RefreshCw,
    Ban,
    ArrowRight,
} from 'lucide-vue-next';

type SuratItem = {
    id: number;
    status: string;
    nomor_surat?: string | null;
    tanggal_pengajuan?: string | null;
    created_at?: string | null;
    pemohon?: { name?: string | null; nim?: string | null } | null;
    jenisSurat?: { id?: number | null; nama?: string | null } | null;
};

type Summary = {
    total: number;
    pending: number;
    validated: number;
    finished: number;
    rejected: number;
    cancelled: number;
};
type PaginatedSurats = {
    data: SuratItem[];
    from?: number | null;
    to?: number | null;
    total: number;
    links: Array<{ url: string | null; label: string; active: boolean }>;
};

type AdminActivityItem = {
    id: number;
    nomor_surat?: string | null;
    keperluan?: string | null;
    tanggal_selesai?: string | null;
    pemohon?: { name?: string | null } | null;
    jenisSurat?: { nama?: string | null } | null;
};

type AdminActivitySummary = {
    recent: AdminActivityItem[];
};

const props = defineProps<{
    auth?: { user?: { name?: string | null } | null };
    surats: PaginatedSurats;
    summary: Summary;
    links: {
        submissionsIndex: string;
    };
}>();

// -- Aksi validasi admin (centang / silang / komen) --------------------------
const approvingId = ref<number | null>(null);
function approveSurat(id: number) {
    if (approvingId.value) return;
    approvingId.value = id;
    router.post(
        `/admin/surat/${id}/approve`,
        {},
        {
            preserveScroll: true,
            onFinish: () => {
                approvingId.value = null;
            },
        },
    );
}

const rejectModalOpen = ref(false);
const rejectTargetId = ref<number | null>(null);
const rejectForm = useForm({ reason: '' });
function openRejectModal(id: number) {
    rejectTargetId.value = id;
    rejectForm.reset();
    rejectModalOpen.value = true;
}
function closeRejectModal() {
    rejectModalOpen.value = false;
    rejectTargetId.value = null;
}
function submitReject() {
    if (rejectTargetId.value === null) return;
    rejectForm.post(`/admin/surat/${rejectTargetId.value}/reject`, {
        preserveScroll: true,
        onSuccess: () => closeRejectModal(),
    });
}

const quickSubmissions = computed(() => props.surats.data.slice(0, 4));
const statCards = computed(() => [
    {
        label: 'Total Pengajuan',
        value: props.summary.total,
        icon: FileText,
        border: 'border-blue-200',
        iconColor: 'text-blue-400',
    },
    {
        label: 'Pending',
        value: props.summary.pending,
        icon: Clock3,
        border: 'border-sky-200',
        iconColor: 'text-sky-400',
    },
    {
        label: 'Selesai',
        value: props.summary.finished,
        icon: CheckCircle2,
        border: 'border-green-200',
        iconColor: 'text-green-400',
    },
    {
        label: 'Ditolak',
        value: props.summary.rejected,
        icon: XCircle,
        border: 'border-red-200',
        iconColor: 'text-red-400',
    },
    {
        label: 'Dibatalkan',
        value: props.summary.cancelled,
        icon: Ban,
        border: 'border-slate-200',
        iconColor: 'text-slate-400',
    },
]);

function statusLabel(s: string) {
    const map: Record<string, string> = {
        pending: 'Pending',
        validated_admin: 'Pending',
        approved_kaprodi: 'Disetujui Kaprodi',
        approved_dekan: 'Disetujui Dekan',
        revision_requested: 'Revisi',
        finished: 'Selesai',
        rejected_admin: 'Ditolak Admin',
        rejected_approver: 'Ditolak Pimpinan',
        cancelled: 'Dibatalkan',
    };
    return map[s] ?? s;
}

function statusClass(s: string) {
    if (s === 'finished') return 'bg-blue-100 text-blue-700';
    if (s === 'rejected_admin' || s === 'rejected_approver')
        return 'bg-red-100 text-red-700';
    if (s === 'revision_requested') return 'bg-amber-100 text-amber-700';
    if (s.startsWith('approved')) return 'bg-blue-100 text-blue-700';
    if (s === 'validated_admin') return 'bg-indigo-100 text-indigo-700';
    if (s === 'cancelled') return 'bg-slate-100 text-slate-600';
    return 'bg-amber-100 text-amber-700';
}

function formatDate(d?: string | null) {
    if (!d) return '-';
    return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    }).format(new Date(d));
}

function historyIcon(action: string) {
    if (action.includes('approved') || action === 'validated') return '?';
    if (action === 'rejected') return '?';
    if (action === 'generated' || action === 'printed') return '?';
    if (action === 'created') return '+';
    return '�';
}

function historyColor(action: string) {
    if (action.includes('approved') || action === 'validated')
        return 'text-blue-600 bg-blue-50';
    if (action === 'rejected') return 'text-red-600 bg-red-50';
    if (action === 'created') return 'text-indigo-600 bg-indigo-50';
    return 'text-slate-500 bg-slate-100';
}

function activityBadgeClass(action?: string | null) {
    const value = String(action ?? '').toLowerCase();
    if (value.includes('approved') || value.includes('validated')) {
        return 'bg-blue-100 text-blue-700';
    }
    if (value.includes('revised') || value.includes('revision')) {
        return 'bg-amber-100 text-amber-700';
    }
    if (value.includes('rejected')) {
        return 'bg-red-100 text-red-700';
    }
    return 'bg-slate-100 text-slate-600';
}

</script>

<template>
    <AdminLayout
        title="Dashboard"
        subtitle="Monitoring pengajuan masuk dan surat keluar"
        active-menu="dashboard"
    >
        <Head title="Dashboard Admin" />

        <div class="mb-6 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
            <div
                v-for="stat in statCards"
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

        <!-- Main grid -->
        <div class="grid gap-6 xl:grid-cols-[1fr_300px]">
            <!-- Tabel surat -->
            <div
                class="overflow-hidden rounded-2xl border border-slate-200 bg-white"
            >
                <!-- Toolbar -->
                <div
                    class="flex flex-col gap-3 border-b border-slate-100 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
                >
                    <div>
                        <h2 class="text-sm font-semibold text-slate-900">
                            Daftar Pengajuan Masuk
                        </h2>
                        <p class="mt-0.5 text-xs text-slate-400">
                            {{ surats?.from ?? 0 }} - {{ surats?.to ?? 0 }} dari
                            {{ surats?.total ?? 0 }}
                        </p>
                    </div>
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-slate-50">
                            <tr
                                class="text-[10px] font-semibold tracking-widest text-slate-400 uppercase"
                            >
                                <th class="px-5 py-3">Pemohon</th>
                                <th class="px-5 py-3">Jenis Surat</th>
                                <th class="px-5 py-3">Tanggal</th>
                                <th class="px-5 py-3">Status</th>
                                <th class="px-5 py-3 text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="surats?.data?.length === 0">
                                <td
                                    colspan="5"
                                    class="px-5 py-12 text-center text-sm text-slate-400"
                                >
                                    Belum ada pengajuan user yang menunggu
                                    proses.
                                </td>
                            </tr>
                            <tr
                                v-for="item in surats?.data ?? []"
                                :key="item.id"
                                class="border-t border-slate-100 text-sm transition-colors hover:bg-slate-50/50"
                            >
                                <td class="px-5 py-3.5">
                                    <p
                                        class="text-xs font-semibold text-slate-900"
                                    >
                                        {{ item.pemohon?.name ?? '-' }}
                                    </p>
                                    <p
                                        class="font-mono text-[10px] text-slate-400"
                                    >
                                        {{ item.pemohon?.nim ?? '-' }}
                                    </p>
                                </td>
                                <td
                                    class="max-w-[160px] truncate px-5 py-3.5 text-xs text-slate-600"
                                >
                                    {{ item.jenisSurat?.nama ?? '-' }}
                                </td>
                                <td class="px-5 py-3.5 text-xs text-slate-400">
                                    {{
                                        formatDate(
                                            item.tanggal_pengajuan ??
                                                item.created_at,
                                        )
                                    }}
                                </td>
                                <td class="px-5 py-3.5">
                                    <span
                                        class="rounded-full px-2 py-1 text-[10px] font-semibold"
                                        :class="statusClass(item.status)"
                                    >
                                        {{ statusLabel(item.status) }}
                                    </span>
                                </td>
                                <td class="px-5 py-3.5">
                                    <div
                                        class="flex items-center justify-end gap-1.5"
                                    >
                                        <Link
                                            :href="`/admin/surat/${item.id}`"
                                            title="Lihat detail"
                                            class="grid size-7 place-items-center rounded-lg bg-slate-100 text-slate-500 transition-colors hover:bg-slate-200"
                                        >
                                            <Eye class="size-3.5" />
                                        </Link>
                                        <button
                                            v-if="item.status === 'pending'"
                                            type="button"
                                            title="Validasi & teruskan"
                                            :disabled="approvingId === item.id"
                                            class="grid size-7 place-items-center rounded-lg bg-blue-50 text-blue-600 transition-colors hover:bg-blue-100 disabled:opacity-50"
                                            @click="approveSurat(item.id)"
                                        >
                                            <CheckCircle2 class="size-3.5" />
                                        </button>
                                        <button
                                            v-if="item.status === 'pending'"
                                            type="button"
                                            title="Tolak (beri komentar)"
                                            class="grid size-7 place-items-center rounded-lg bg-red-50 text-red-600 transition-colors hover:bg-red-100"
                                            @click="openRejectModal(item.id)"
                                        >
                                            <XCircle class="size-3.5" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>

            <!-- Kanan: Ringkasan & Info -->
            <div class="space-y-4">
                <!-- Aktivitas Terbaru -->
                <div class="rounded-2xl border border-slate-200 bg-white p-4">
                    <h3
                        class="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900"
                    >
                        <Clock3 class="size-4 text-blue-500" /> Ringkasan Cepat
                    </h3>
                    <div class="space-y-3">
                        <template v-if="quickSubmissions.length">
                            <div
                                v-for="item in quickSubmissions"
                                :key="item.id"
                                class="rounded-xl border border-slate-100 bg-slate-50 p-3"
                            >
                                <div class="flex items-start gap-2">
                                    <div
                                        class="mt-1.5 size-1.5 rounded-full bg-blue-500"
                                    />
                                    <div class="min-w-0 flex-1">
                                        <p
                                            class="truncate text-xs font-medium text-slate-700"
                                        >
                                            {{ item.pemohon?.name ?? '-' }}
                                        </p>
                                        <p class="text-[10px] text-slate-400">
                                            {{ item.jenisSurat?.nama ?? '-' }}
                                        </p>
                                        <div class="mt-1 flex items-center gap-2">
                                            <span
                                                class="rounded-full px-2 py-0.5 text-[10px] font-semibold"
                                                :class="
                                                    statusClass(item.status)
                                                "
                                            >
                                                {{ statusLabel(item.status) }}
                                            </span>
                                            <span class="text-[10px] text-slate-400">
                                                {{
                                                    formatDate(
                                                        item.tanggal_pengajuan ??
                                                            item.created_at,
                                                    )
                                                }}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </template>
                        <p v-else class="text-xs text-slate-400">
                            Belum ada pengajuan
                        </p>
                    </div>
                    <div class="mt-3 border-t border-slate-100 pt-3">
                        <Link
                            :href="props.links.submissionsIndex"
                            class="inline-flex items-center gap-1 text-xs font-medium text-blue-600 transition-colors hover:text-blue-700"
                        >
                            Lihat Selengkapnya
                            <ArrowRight class="size-3.5" />
                        </Link>
                    </div>
                </div>

            </div>
        </div>

        <!-- Modal Tolak Pengajuan (komentar) -->
        <Transition name="fade">
            <div
                v-if="rejectModalOpen"
                class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm"
                @click.self="closeRejectModal"
            >
                <div
                    class="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-6 shadow-xl"
                >
                    <div class="mb-4 flex items-center gap-3">
                        <div
                            class="grid size-10 shrink-0 place-items-center rounded-xl bg-red-50"
                        >
                            <AlertTriangle class="size-5 text-red-500" />
                        </div>
                        <div>
                            <h3 class="text-sm font-semibold text-slate-900">
                                Tolak Pengajuan
                            </h3>
                            <p class="text-xs text-slate-400">
                                Berikan komentar/alasan penolakan untuk pemohon.
                            </p>
                        </div>
                        <button
                            type="button"
                            class="ml-auto rounded-lg p-1 text-slate-400 hover:bg-slate-100"
                            @click="closeRejectModal"
                        >
                            <X class="size-4" />
                        </button>
                    </div>
                    <textarea
                        v-model="rejectForm.reason"
                        rows="4"
                        placeholder="Jelaskan alasan penolakan..."
                        class="w-full resize-none rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900 placeholder-slate-400 outline-none focus:border-red-400 focus:ring-2 focus:ring-red-100"
                    />
                    <p
                        v-if="rejectForm.errors.reason"
                        class="mt-1 text-xs text-red-500"
                    >
                        {{ rejectForm.errors.reason }}
                    </p>
                    <div class="mt-4 flex justify-end gap-2">
                        <button
                            type="button"
                            class="rounded-xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50"
                            @click="closeRejectModal"
                        >
                            Batal
                        </button>
                        <button
                            type="button"
                            class="rounded-xl bg-red-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-red-700 disabled:opacity-50"
                            :disabled="
                                rejectForm.processing ||
                                !rejectForm.reason.trim()
                            "
                            @click="submitReject"
                        >
                            {{
                                rejectForm.processing
                                    ? 'Memproses...'
                                    : 'Tolak Pengajuan'
                            }}
                        </button>
                    </div>
                </div>
            </div>
        </Transition>
    </AdminLayout>
</template>

<!-- <style scoped> //error
.badge-green  { @apply bg-emerald-100 text-emerald-700; }
.badge-red    { @apply bg-red-100 text-red-700; }
.badge-amber  { @apply bg-amber-100 text-amber-700; }
.badge-blue   { @apply bg-blue-100 text-blue-700; }
.badge-indigo { @apply bg-indigo-100 text-indigo-700; }
</style> -->

<!-- <style scoped>  //opsi pertama
@reference "tailwindcss";

.badge-green  { @apply bg-emerald-100 text-emerald-700; }
.badge-red    { @apply bg-red-100 text-red-700; }
.badge-amber  { @apply bg-amber-100 text-amber-700; }
.badge-blue   { @apply bg-blue-100 text-blue-700; }
.badge-indigo { @apply bg-indigo-100 text-indigo-700; }
</style> -->
