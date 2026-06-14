<script setup lang="ts">
// resources/js/pages/FASt/admin/letters/Index.vue
import AdminLayout from '@/layouts/FASt/AdminLayout.vue';
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import {
    Eye,
    CheckCircle2,
    Search,
    XCircle,
    AlertTriangle,
    X,
    FileEdit,
    BarChart3,
    ChevronDown,
} from 'lucide-vue-next';
type SuratItem = {
    id: number;
    status: string;
    revision_label?: string | null;
    can_edit?: boolean;
    nomor_surat?: string | null;
    keperluan?: string | null;
    tanggal_pengajuan?: string | null;
    created_at?: string | null;
    tanggal_selesai?: string | null;
    pemohon?: { name?: string | null; nim?: string | null } | null;
    jenisSurat?: {
        id?: number | null;
        nama?: string | null;
        category?: { nama?: string | null } | null;
    } | null;
};
type Paginated = {
    data: SuratItem[];
    from?: number | null;
    to?: number | null;
    total: number;
    links: Array<{ url: string | null; label: string; active: boolean }>;
};
type Summary = {
    total: number;
    pending: number;
    finished: number;
    rejected: number;
};
const props = defineProps<{
    surats: Paginated;
    summary: Summary;
    filters: { status?: string; search?: string; jenis_surat_id?: string };
    categories: Array<{ id: number; nama: string }>;
}>();
const summary = props.summary;
const search = ref(props.filters.search ?? '');
const status = ref(props.filters.status ?? '');
const jenisSuratId = ref(props.filters.jenis_surat_id ?? '');

const statusFilters = computed(() => [
    {
        key: 'pending',
        label: 'Pending',
        color: 'amber' as const,
    },
    {
        key: 'rejected_admin',
        label: 'Ditolak',
        color: 'red' as const,
    },
    { key: 'all', label: 'Semua', color: 'blue' as const },
]);

function applyFilter() {
    router.get(
        '/admin/surat',
        {
            search: search.value || undefined,
            status: status.value || undefined,
            jenis_surat_id: jenisSuratId.value || undefined,
        },
        { preserveState: true, replace: true },
    );
}
function resetFilter() {
    search.value = '';
    status.value = '';
    jenisSuratId.value = '';
    applyFilter();
}
const rejectModalOpen = ref(false);
const rejectTargetId = ref<number | null>(null);
const rejectForm = useForm({ reason: '' });
const approvingId = ref<number | null>(null);
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
function formatDate(d?: string | null) {
    if (!d) return '-';
    return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    }).format(new Date(d));
}
function statusLabel(item: SuratItem) {
    const map: Record<string, string> = {
        pending: 'Pending',
        validated_admin: 'Validasi Admin',
        approved_kaprodi: 'Disetujui Kaprodi',
        approved_dekan: 'Disetujui Dekan',
        revision_requested: 'Ditolak',
        finished: 'Selesai',
        rejected_admin: 'Ditolak',
        rejected_approver: 'Ditolak Pimpinan',
    };
    return map[item.status] ?? item.status;
}
function statusClass(s: string) {
    if (s === 'finished') return 'bg-blue-100 text-blue-700';
    if (s === 'revision_requested') return 'bg-amber-100 text-amber-700';
    if (s === 'rejected_admin' || s === 'rejected_approver')
        return 'bg-red-100 text-red-700';
    if (s.startsWith('approved')) return 'bg-sky-100 text-sky-700';
    if (s === 'validated_admin') return 'bg-indigo-100 text-indigo-700';
    return 'bg-slate-100 text-slate-600';
}
function initials(name?: string | null) {
    if (!name) return '?';
    return name
        .split(' ')
        .map((w) => w[0])
        .slice(0, 2)
        .join('')
        .toUpperCase();
}
</script>
<template>
    <AdminLayout
        title="Pengajuan Masuk"
        subtitle="Permohonan user yang menunggu proses admin"
        active-menu="letters.index"
        :breadcrumbs="[{ label: 'Pengajuan Masuk' }]"
    >
        <Head title="Pengajuan Masuk" />
        <!-- Top bar: search + tombol -->
        <div class="mb-4 rounded-2xl border border-slate-200 bg-white p-4">
            <div class="flex flex-wrap items-center gap-2">
                <div class="relative min-w-[240px] flex-1">
                <Search
                    class="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-slate-400"
                />
                <input
                    v-model="search"
                    type="text"
                    placeholder="Cari nama atau NIM pemohon..."
                    class="h-10 w-full rounded-xl border border-slate-200 bg-white pr-3 pl-10 text-sm text-slate-700 outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100"
                    @keyup.enter="applyFilter"
                />
                </div>
                <div class="relative min-w-[200px]">
                    <select
                        v-model="jenisSuratId"
                        class="h-10 w-full appearance-none rounded-xl border border-slate-200 bg-white pr-8 pl-3 text-sm text-slate-700 outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100"
                    >
                        <option value="">Semua Kategori</option>
                        <option
                            v-for="j in categories"
                            :key="j.id"
                            :value="String(j.id)"
                        >
                            {{ j.nama }}
                        </option>
                    </select>
                    <ChevronDown
                        class="pointer-events-none absolute top-1/2 right-3 size-3.5 -translate-y-1/2 text-slate-400"
                    />
                </div>
                <button
                    type="button"
                    class="h-10 rounded-xl bg-blue-600 px-5 text-sm font-semibold text-white transition-colors hover:bg-blue-700"
                    @click="applyFilter"
                >
                    Terapkan
                </button>
                <button
                    type="button"
                    class="h-10 rounded-xl border border-slate-200 px-5 text-sm text-slate-500 transition-colors hover:bg-slate-50"
                    @click="resetFilter"
                >
                    Reset
                </button>
            </div>
            <div class="mt-4 flex flex-wrap items-center gap-2">
                <button
                    v-for="filter in statusFilters"
                    :key="filter.key || 'all'"
                    type="button"
                    class="rounded-full border px-3 py-1.5 text-xs font-medium transition-colors"
                    :class="
                        status === filter.key
                            ? filter.color === 'red'
                                ? 'border-red-500 bg-red-500 text-white shadow-sm'
                                : filter.color === 'amber'
                                  ? 'border-amber-500 bg-amber-500 text-white shadow-sm'
                                  : 'border-blue-500 bg-blue-500 text-white shadow-sm'
                            : 'border-slate-200 bg-white text-slate-500 hover:border-slate-300'
                    "
                    @click="
                        status = filter.key;
                        applyFilter();
                    "
                >
                    {{ filter.label }}
                </button>
            </div>
        </div>
        <!-- Card list with colored left border stripe -->
        <div class="space-y-2">
            <div
                v-if="surats.data.length === 0"
                class="flex flex-col items-center gap-3 py-16 text-center"
            >
                <div
                    class="grid size-16 place-items-center rounded-2xl border border-slate-100 bg-slate-50"
                >
                    <BarChart3 class="size-8 text-slate-200" />
                </div>
                <p class="text-sm font-medium text-slate-400">
                    Tidak ada pengajuan
                </p>
                <p class="text-xs text-slate-300">
                    Coba ubah filter atau cari dengan kata kunci lain
                </p>
            </div>
            <div
                v-for="item in surats.data"
                :key="item.id"
                        class="group relative flex items-start gap-0 overflow-hidden rounded-xl border border-slate-200 bg-white transition-all hover:shadow-md"
                    :class="[
                    item.status === 'finished'
                        ? 'hover:border-blue-300'
                        : item.status.startsWith('approved')
                          ? 'hover:border-sky-300'
                          : item.status === 'rejected_admin' ||
                              item.status === 'rejected_approver'
                            ? 'hover:border-red-300'
                            : item.status === 'revision_requested'
                              ? 'hover:border-amber-300'
                              : 'hover:border-indigo-300',
                ]"
            >
                <!-- Colored left stripe -->
                <div
                    class="w-1.5 shrink-0 self-stretch"
                    :class="[
                        item.status === 'finished'
                            ? 'bg-blue-400'
                            : item.status.startsWith('approved')
                              ? 'bg-sky-400'
                              : item.status === 'rejected_admin' ||
                                  item.status === 'rejected_approver'
                                ? 'bg-red-400'
                                : item.status === 'revision_requested'
                                  ? 'bg-amber-400'
                                  : 'bg-indigo-400',
                    ]"
                />
                <div class="flex-1 p-4">
                    <div
                        class="flex flex-col gap-3 sm:flex-row sm:items-center"
                    >
                        <!-- Main info: avatar + name + surat -->
                        <div class="flex min-w-0 flex-1 items-center gap-3">
                            <div
                                class="grid size-9 shrink-0 place-items-center rounded-full bg-slate-100 text-[10px] font-bold text-slate-500"
                            >
                                {{ initials(item.pemohon?.name) }}
                            </div>
                            <div class="min-w-0">
                                <div class="flex flex-wrap items-center gap-2">
                                    <p
                                        class="truncate text-sm font-semibold text-slate-900"
                                    >
                                        {{ item.pemohon?.name ?? '-' }}
                                    </p>
                                    <span
                                        class="inline-block rounded-full px-2 py-0.5 text-[10px] font-semibold"
                                        :class="statusClass(item.status)"
                                    >
                                        {{ statusLabel(item) }}
                                    </span>
                                </div>
                                <div class="mt-0.5 flex items-center gap-2">
                                    <p class="text-xs text-slate-500">
                                        {{ item.jenisSurat?.nama ?? '-' }}
                                    </p>
                                    <span class="text-slate-300">·</span>
                                    <p
                                        class="font-mono text-[10px] text-slate-400"
                                    >
                                        {{ item.nomor_surat ?? '-' }}
                                    </p>
                                </div>
                            </div>
                        </div>
                        <!-- Date -->
                        <div class="shrink-0 text-right sm:text-left">
                            <p class="text-[10px] text-slate-400">
                                {{
                                    formatDate(
                                        item.tanggal_pengajuan ??
                                            item.created_at,
                                    )
                                }}
                            </p>
                        </div>
                        <!-- Actions -->
                        <div class="flex shrink-0 items-center gap-2">
                            <Link
                                :href="`/admin/surat/${item.id}`"
                                class="flex items-center gap-1 rounded-lg border border-slate-200 px-2.5 py-1.5 text-[10px] font-medium text-slate-600 transition-colors hover:border-blue-200 hover:bg-blue-50 hover:text-blue-600"
                                title="Lihat Detail"
                            >
                                <Eye class="size-3" /> Detail
                            </Link>
                            <button
                                v-if="item.status === 'pending'"
                                type="button"
                                :disabled="approvingId === item.id"
                                class="flex items-center gap-1 rounded-lg bg-blue-600 px-2.5 py-1.5 text-[10px] font-medium text-white transition-colors hover:bg-blue-700 disabled:opacity-50"
                                title="Validasi & Teruskan"
                                @click="approveSurat(item.id)"
                            >
                                <CheckCircle2 class="size-3" /> Proses
                            </button>
                            <Link
                                v-if="
                                    item.status === 'revision_requested' &&
                                    item.can_edit
                                "
                                :href="`/admin/surat/${item.id}/edit`"
                                class="flex items-center gap-1 rounded-lg bg-amber-600 px-2.5 py-1.5 text-[10px] font-medium text-white transition-colors hover:bg-amber-700"
                                title="Edit & Teruskan"
                            >
                                <CheckCircle2 class="size-3" /> Proses Ulang
                            </Link>
                            <button
                                v-if="item.status === 'pending'"
                                type="button"
                                class="flex items-center gap-1 rounded-lg border border-red-200 px-2.5 py-1.5 text-[10px] font-medium text-red-600 transition-colors hover:bg-red-50"
                                title="Tolak"
                                @click="openRejectModal(item.id)"
                            >
                                <XCircle class="size-3" /> Tolak
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Pagination -->
        <div
            v-if="surats.links.length > 3"
            class="mt-5 flex flex-wrap items-center gap-1.5"
        >
            <Link
                v-for="link in surats.links"
                :key="link.label"
                :href="link.url ?? '#'"
                class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                :class="[
                    link.active
                        ? 'bg-blue-600 text-white'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200',
                    !link.url ? 'pointer-events-none opacity-40' : '',
                ]"
                v-html="link.label"
            />
        </div>
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
                                Berikan komentar atau alasan penolakan untuk
                                pemohon.
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
