<script setup lang="ts">
// File: resources/js/layouts/FASt/AdminLayout.vue
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { computed, ref, onMounted, onUnmounted, watch } from 'vue';
import {
    LayoutDashboard,
    FilePlus2,
    ClipboardList,
    Archive,
    FileCode2,
    Tag,
    Settings,
    LogOut,
    Bell,
    ChevronRight,
    Menu,
    X,
    History,
    QrCode,
    Battery,
    BatteryCharging,
    BatteryLow,
    BatteryMedium,
    BatteryFull,
    Clock,
} from 'lucide-vue-next';

type BreadcrumbItem = { label: string; href?: string };
type PageProps = {
    auth?: {
        user?: {
            name?: string;
            email?: string;
            role?: { nama?: string; slug?: string };
        };
    };
    flash?: { success?: string; error?: string; warning?: string };
    notif_count?: number;
    notif_count_revision_admin?: number;
};

const props = withDefaults(
    defineProps<{
        title: string;
        subtitle?: string;
        activeMenu?: string;
        breadcrumbs?: BreadcrumbItem[];
    }>(),
    {
        subtitle: '',
        activeMenu: 'dashboard',
        breadcrumbs: () => [],
    },
);

const page = usePage<PageProps>();
const sidebarOpen = ref(true);
const mobileOpen = ref(false);
const isMobile = ref(false);

const user = computed(() => page.props.auth?.user);
const userName = computed(() => user.value?.name ?? 'Admin');
const userRole = computed(() => user.value?.role?.nama ?? 'Administrator');
const userSlug = computed(() => user.value?.role?.slug ?? 'admin');
const userInitials = computed(() =>
    userName.value
        .split(' ')
        .slice(0, 2)
        .map((n: string) => n[0])
        .join('')
        .toUpperCase(),
);
const notifCount = computed(() => page.props.notif_count ?? 0);
const notifCountRevisionAdmin = computed(
    () => page.props.notif_count_revision_admin ?? 0,
);
const flashSuccess = computed(() => page.props.flash?.success);
const flashError = computed(() => page.props.flash?.error);
const flashWarning = computed(() => page.props.flash?.warning);

function checkMobile() {
    isMobile.value = window.innerWidth < 1024;
    if (isMobile.value) sidebarOpen.value = false;
    else mobileOpen.value = false;
}
onMounted(() => {
    checkMobile();
    window.addEventListener('resize', checkMobile);
});
onUnmounted(() => window.removeEventListener('resize', checkMobile));
watch(
    () => page.url,
    () => {
        mobileOpen.value = false;
    },
);

type NavItem = {
    key: string;
    label: string;
    href: string;
    icon: unknown;
    badge?: number | string;
    badgeColor?: string;
    onlyFor?: string[]; // role slugs yang boleh lihat
};

const navItems = computed<NavItem[]>(() => {
    const slug = userSlug.value;
    const isAdminRole = ['admin'].includes(slug);
    const isApproverRole = ['kaprodi', 'dekan'].includes(slug);
    const isDosenRole =
        !isAdminRole &&
        !isApproverRole &&
        (slug.includes('dosen') || slug === 'lecturer');

    if (isAdminRole) {
        return [
            {
                key: 'dashboard',
                label: 'Dashboard',
                href: '/admin/dashboard',
                icon: LayoutDashboard,
            },
            {
                key: 'letters.create',
                label: 'Buat Surat',
                href: '/admin/surat/create',
                icon: FilePlus2,
            },
            {
                key: 'letters.index',
                label: 'Pengajuan',
                href: '/admin/surat',
                icon: ClipboardList,
                badge: notifCount.value || undefined,
                badgeColor: 'amber',
            },
            {
                key: 'history',
                label: 'Riwayat Admin',
                href: '/admin/history',
                icon: History,
                badge: notifCountRevisionAdmin.value || undefined,
                badgeColor: 'red',
            },
            {
                key: 'archive',
                label: 'Arsip',
                href: '/admin/archive',
                icon: Archive,
            },
            {
                key: 'templates',
                label: 'Template',
                href: '/admin/templates',
                icon: FileCode2,
            },
            {
                key: 'categories',
                label: 'Kategori',
                href: '/admin/categories',
                icon: Tag,
            },
            { key: 'qr', label: 'QR Code', href: '/admin/qr', icon: QrCode },
        ];
    }
    if (isApproverRole) {
        return [
            {
                key: 'approval.dashboard',
                label: 'Dashboard',
                href: `/${slug}/dashboard`,
                icon: LayoutDashboard,
            },
            {
                key: 'approval.antrian',
                label: 'Antrian Approval',
                href: `/${slug}/antrian`,
                icon: Clock,
                badge: notifCount.value || undefined,
                badgeColor: 'amber',
            },
            {
                key: 'approval.arsip',
                label: 'Riwayat Approval',
                href: `/${slug}/arsip`,
                icon: Archive,
            },
        ];
    }
    if (isDosenRole) {
        return [
            {
                key: 'dashboard',
                label: 'Dashboard',
                href: `/${slug}/dashboard`,
                icon: LayoutDashboard,
            },
            {
                key: 'history',
                label: 'Riwayat',
                href: `/${slug}/history`,
                icon: History,
            },
        ];
    }
    return [];
});

function isActive(key: string) {
    return props.activeMenu === key || props.activeMenu?.startsWith(key + '.');
}

function toggleSidebar() {
    if (isMobile.value) mobileOpen.value = !mobileOpen.value;
    else sidebarOpen.value = !sidebarOpen.value;
}

function logout() {
    router.flushAll();
    router.post('/logout');
}

const showSidebar = computed(() => (isMobile.value ? mobileOpen.value : true));
const sidebarExpanded = computed(() =>
    isMobile.value ? true : sidebarOpen.value,
);

// ── Clock & Battery widget ───────────────────────────────────────────────
const now = ref(new Date());
let clockTimer: ReturnType<typeof setInterval> | null = null;

const dateStr = computed(() =>
    new Intl.DateTimeFormat('id-ID', {
        weekday: 'short',
        day: '2-digit',
        month: 'short',
        year: 'numeric',
    }).format(now.value),
);
const timeStr = computed(() =>
    new Intl.DateTimeFormat('id-ID', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
    }).format(now.value),
);

interface BatteryInfo {
    level: number;
    charging: boolean;
}
const battery = ref<BatteryInfo | null>(null);

onMounted(() => {
    clockTimer = setInterval(() => {
        now.value = new Date();
    }, 1000);

    const nav = navigator as any;
    if (nav.getBattery) {
        nav.getBattery()
            .then((bat: any) => {
                const update = () => {
                    battery.value = {
                        level: Math.round(bat.level * 100),
                        charging: bat.charging,
                    };
                };
                update();
                bat.addEventListener('levelchange', update);
                bat.addEventListener('chargingchange', update);
            })
            .catch(() => {
                /* ignore */
            });
    }
});

onUnmounted(() => {
    if (clockTimer) clearInterval(clockTimer);
});

function batteryIcon() {
    if (!battery.value) return Battery;
    if (battery.value.charging) return BatteryCharging;
    if (battery.value.level <= 20) return BatteryLow;
    if (battery.value.level <= 50) return BatteryMedium;
    return BatteryFull;
}
</script>

<template>
    <Head :title="title" />

    <div class="flex h-screen overflow-hidden bg-slate-50 font-sans">
        <!-- Mobile overlay -->
        <Transition name="fade">
            <div
                v-if="isMobile && mobileOpen"
                class="fixed inset-0 z-20 bg-black/40 lg:hidden"
                @click="mobileOpen = false"
            />
        </Transition>

        <!-- ── Sidebar ── -->
        <aside
            v-show="showSidebar"
            class="fixed inset-y-0 left-0 z-30 flex flex-col border-r border-slate-200 bg-white lg:relative lg:z-auto"
            :class="sidebarExpanded ? 'w-56' : 'w-[60px]'"
        >
            <!-- Logo -->
            <div
                class="flex h-14 shrink-0 items-center gap-2.5 border-b border-slate-100 px-3"
            >
                <img
                    src="/logo.png"
                    alt="Logo Kampus"
                    class="h-8 w-auto shrink-0 rounded-md object-contain"
                />
                <div v-if="sidebarExpanded" class="min-w-0 overflow-hidden">
                    <p
                        class="truncate text-[13px] font-bold tracking-tight text-slate-900"
                    >
                        FAST Academic
                    </p>
                    <p
                        class="text-[10px] tracking-widest text-slate-400 uppercase"
                    >
                        FMIKOM
                    </p>
                </div>
            </div>

            <!-- User chip -->
            <div class="shrink-0 px-2 pt-3">
                <div
                    class="flex items-center gap-2 rounded-xl px-2 py-2"
                    :class="sidebarExpanded ? 'bg-slate-50' : 'justify-center'"
                >
                    <div
                        class="grid size-7 shrink-0 place-items-center rounded-lg bg-blue-500 text-[11px] font-bold text-white"
                    >
                        {{ userInitials }}
                    </div>
                    <div v-if="sidebarExpanded" class="min-w-0">
                        <p
                            class="truncate text-xs font-semibold text-slate-900"
                        >
                            {{ userName }}
                        </p>
                        <p class="truncate text-[10px] text-slate-400">
                            {{ userRole }}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Clock & Battery widget -->
            <div
                v-if="sidebarExpanded"
                class="mx-2 mt-2 mb-1 rounded-xl border border-slate-100 bg-slate-50/80 px-3 py-2"
            >
                <div class="flex items-center justify-between gap-2">
                    <p class="truncate text-[10px] font-medium text-slate-500">
                        {{ dateStr }}
                    </p>
                    <div class="flex shrink-0 items-center gap-1.5">
                        <p
                            class="font-mono text-[10px] font-semibold text-slate-700"
                        >
                            {{ timeStr }}
                        </p>
                        <component
                            v-if="battery"
                            :is="batteryIcon()"
                            class="size-3.5 text-slate-400"
                        />
                    </div>
                </div>
                <div
                    v-if="battery"
                    class="mt-1 flex items-center gap-1 text-[10px] text-slate-400"
                >
                    <span
                        class="inline-block size-1 rounded-full"
                        :class="
                            battery.level <= 20
                                ? 'bg-red-500'
                                : battery.charging
                                  ? 'bg-green-500'
                                  : 'bg-blue-500'
                        "
                    />
                    {{ battery.level }}% {{ battery.charging ? 'Mengisi' : '' }}
                </div>
            </div>

            <!-- Nav -->
            <nav class="flex-1 overflow-x-hidden overflow-y-auto px-2 py-2">
                <Link
                    v-for="item in navItems"
                    :key="item.key + item.label"
                    :href="item.href"
                    :prefetch="false"
                    class="mb-1 flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-colors"
                    :class="[
                        isActive(item.key)
                            ? 'bg-blue-500 text-white shadow-sm'
                            : 'text-slate-500 hover:bg-slate-100 hover:text-slate-700',
                        !sidebarExpanded ? 'justify-center' : '',
                    ]"
                    :title="!sidebarExpanded ? item.label : undefined"
                >
                    <component
                        :is="item.icon"
                        class="size-5 shrink-0"
                        :class="
                            isActive(item.key) ? 'text-white' : 'text-slate-400'
                        "
                    />
                    <span v-if="sidebarExpanded" class="flex-1 truncate">{{
                        item.label
                    }}</span>
                    <span
                        v-if="sidebarExpanded && item.badge"
                        class="rounded-full px-1.5 py-0.5 text-[10px] leading-none font-bold"
                        :class="
                            item.badgeColor === 'amber'
                                ? 'bg-amber-100 text-amber-700'
                                : item.badgeColor === 'red'
                                  ? 'bg-red-100 text-red-700'
                                : 'bg-blue-100 text-blue-700'
                        "
                    >
                        {{ item.badge }}
                    </span>
                </Link>
            </nav>

            <!-- Bottom -->
            <div class="shrink-0 border-t border-slate-100 px-2 py-2">
                <Link
                    href="/settings/profile"
                    :prefetch="false"
                    class="flex items-center gap-2.5 rounded-lg px-2 py-2 text-[13px] font-medium text-slate-500 transition-colors hover:bg-slate-50 hover:text-slate-700"
                    :class="!sidebarExpanded ? 'justify-center' : ''"
                    :title="!sidebarExpanded ? 'Pengaturan' : undefined"
                >
                    <Settings class="size-4 shrink-0 text-slate-400" />
                    <span v-if="sidebarExpanded">Pengaturan</span>
                </Link>
                <button
                    type="button"
                    class="flex w-full items-center gap-2.5 rounded-lg px-2 py-2 text-[13px] font-medium text-red-500 transition-colors hover:bg-red-50"
                    :class="!sidebarExpanded ? 'justify-center' : ''"
                    :title="!sidebarExpanded ? 'Keluar' : undefined"
                    @click="logout"
                >
                    <LogOut class="size-4 shrink-0" />
                    <span v-if="sidebarExpanded">Keluar</span>
                </button>
            </div>
        </aside>

        <!-- ── Content ── -->
        <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
            <!-- Topbar -->
            <header
                class="flex h-14 shrink-0 items-center justify-between border-b border-slate-200 bg-white px-4 lg:px-5"
            >
                <div class="flex items-center gap-3">
                    <button
                        type="button"
                        class="rounded-lg p-1.5 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-600"
                        @click="toggleSidebar"
                    >
                        <Menu class="size-5" />
                    </button>

                    <!-- Breadcrumb -->
                    <nav class="hidden items-center gap-1 text-sm md:flex">
                        <span class="text-slate-400">FAST</span>
                        <ChevronRight class="size-3.5 text-slate-300" />
                        <template v-if="props.breadcrumbs?.length">
                            <template
                                v-for="(bc, i) in props.breadcrumbs"
                                :key="i"
                            >
                                <Link
                                    v-if="bc.href"
                                    :href="bc.href"
                                    :prefetch="false"
                                    class="text-slate-400 transition-colors hover:text-slate-600"
                                >
                                    {{ bc.label }}
                                </Link>
                                <span
                                    v-else
                                    class="font-medium text-slate-800"
                                    >{{ bc.label }}</span
                                >
                                <ChevronRight
                                    v-if="i < props.breadcrumbs.length - 1"
                                    class="size-3.5 text-slate-300"
                                />
                            </template>
                        </template>
                        <span v-else class="font-medium text-slate-800">{{
                            props.title
                        }}</span>
                    </nav>
                </div>

                <!-- Right -->
                <div class="flex items-center gap-2">
                    <button
                        type="button"
                        class="relative rounded-lg border border-slate-200 bg-white p-1.5 text-slate-500 transition-colors hover:bg-slate-50"
                    >
                        <Bell class="size-4" />
                        <span
                            v-if="notifCount > 0"
                            class="absolute -top-1 -right-1 flex size-4 items-center justify-center rounded-full bg-red-500 text-[9px] font-bold text-white"
                        >
                            {{ notifCount > 9 ? '9+' : notifCount }}
                        </span>
                    </button>
                </div>
            </header>

            <!-- Flash messages -->
            <div class="shrink-0">
                <Transition name="flash">
                    <div
                        v-if="flashSuccess"
                        class="mx-4 mt-3 flex items-center gap-2.5 rounded-xl border border-blue-200 bg-blue-50 px-4 py-2.5"
                    >
                        <div
                            class="flex size-5 shrink-0 items-center justify-center rounded-full bg-blue-500"
                        >
                            <svg
                                class="size-3 text-white"
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
                        <p class="text-sm font-medium text-blue-800">
                            {{ flashSuccess }}
                        </p>
                    </div>
                </Transition>
                <Transition name="flash">
                    <div
                        v-if="flashError"
                        class="mx-4 mt-3 flex items-center gap-2.5 rounded-xl border border-red-200 bg-red-50 px-4 py-2.5"
                    >
                        <div
                            class="flex size-5 shrink-0 items-center justify-center rounded-full bg-red-500"
                        >
                            <X class="size-3 text-white" />
                        </div>
                        <p class="text-sm font-medium text-red-800">
                            {{ flashError }}
                        </p>
                    </div>
                </Transition>
                <Transition name="flash">
                    <div
                        v-if="flashWarning"
                        class="mx-4 mt-3 flex items-center gap-2.5 rounded-xl border border-amber-200 bg-amber-50 px-4 py-2.5"
                    >
                        <p class="text-sm font-medium text-amber-800">
                            ⚠ {{ flashWarning }}
                        </p>
                    </div>
                </Transition>
            </div>

            <!-- Page header -->
            <div
                v-if="subtitle || $slots.actions"
                class="flex shrink-0 items-center justify-between gap-4 border-b border-slate-100 bg-white px-5 py-3.5"
            >
                <div>
                    <p v-if="subtitle" class="text-xs text-slate-400">
                        {{ subtitle }}
                    </p>
                    <h1 class="text-lg font-semibold text-slate-900">
                        {{ title }}
                    </h1>
                </div>
                <div
                    v-if="$slots.actions"
                    class="flex shrink-0 items-center gap-2"
                >
                    <slot name="actions" />
                </div>
            </div>

            <!-- Main content -->
            <main class="flex-1 overflow-y-auto pb-16 lg:pb-0">
                <div class="mx-auto max-w-screen-xl p-4 lg:p-6">
                    <slot />
                </div>
            </main>
        </div>

        <!-- Mobile Bottom Bar -->
        <div
            class="fixed right-0 bottom-0 left-0 z-40 border-t border-slate-100 bg-white px-1 py-2 lg:hidden"
        >
            <div class="flex items-center justify-around">
                <Link
                    v-for="item in navItems.slice(0, 5)"
                    :key="item.key + 'mb'"
                    :href="item.href"
                    :prefetch="false"
                    class="flex flex-col items-center gap-0.5 rounded-lg px-2 py-1 text-[10px] font-medium transition-colors"
                    :class="
                        isActive(item.key) ? 'text-blue-600' : 'text-slate-400'
                    "
                >
                    <component :is="item.icon" class="size-5" />
                    <span>{{ item.label }}</span>
                    <span
                        v-if="item.badge"
                        class="absolute top-1 right-1/4 flex h-3.5 min-w-[14px] translate-x-2 -translate-y-0.5 items-center justify-center rounded-full bg-red-500 px-1 text-[8px] font-bold text-white"
                    >
                        {{ item.badge }}
                    </span>
                </Link>
            </div>
        </div>
    </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.15s;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
.flash-enter-active,
.flash-leave-active {
    transition: all 0.2s;
}
.flash-enter-from,
.flash-leave-to {
    opacity: 0;
    transform: translateY(-6px);
}
</style>
