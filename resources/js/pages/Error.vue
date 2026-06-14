<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps<{
    status: number;
    message: string;
}>();

const title = computed(() => `Error ${props.status}`);
</script>

<template>
    <Head :title="title" />

    <div class="flex min-h-screen items-center justify-center bg-gradient-to-br from-slate-950 via-slate-900 to-emerald-950 px-4 py-10">
        <div class="w-full max-w-lg rounded-3xl border border-white/10 bg-white/95 p-8 shadow-2xl shadow-black/30 backdrop-blur">
            <p class="text-sm font-semibold uppercase tracking-[0.24em] text-emerald-700">FAST Academic</p>
            <div class="mt-4 flex items-end gap-3">
                <span class="text-5xl font-black text-slate-900">{{ status }}</span>
                <span class="pb-1 text-sm text-slate-500">Permintaan tidak dapat diproses</span>
            </div>
            <p class="mt-4 text-base leading-7 text-slate-700">{{ message }}</p>

            <div class="mt-8 flex flex-wrap gap-3">
                <Link
                    href="/dashboard"
                    class="inline-flex items-center justify-center rounded-2xl bg-emerald-600 px-5 py-3 text-sm font-semibold text-white transition hover:bg-emerald-700"
                >
                    Kembali ke Dashboard
                </Link>
                <Link
                    href="/"
                    class="inline-flex items-center justify-center rounded-2xl border border-slate-200 px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50"
                >
                    Halaman Awal
                </Link>
            </div>
        </div>
    </div>
</template>
