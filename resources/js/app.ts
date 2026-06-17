import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import type { DefineComponent } from 'vue';
import { createApp, h } from 'vue';
import '../css/app.css';
import { initializeTheme } from '@/composables/useAppearance';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

function resolveFastPageName(name: string): string {
    if (name.startsWith('approval/')) return `FASt/Shared/${name}`;
    if (name.startsWith('kaprodi/approval/')) return `FASt/${name}`;
    if (name.startsWith('dekan/approval/')) return `FASt/${name}`;
    if (name.startsWith('mahasiswa/')) return `FASt/${name}`;
    if (name.startsWith('dosen/')) return `FASt/${name}`;
    if (name.startsWith('admin/')) return `FASt/${name}`;
    if (name.startsWith('fast/user/')) {
        return `FASt/mahasiswa/${name.slice('fast/user/'.length)}`;
    }
    if (name.startsWith('fast/mahasiswa/')) {
        return `FASt/mahasiswa/${name.slice('fast/mahasiswa/'.length)}`;
    }

    return name;
}

createInertiaApp({
    title: (title) => (title ? `${title} - ${appName}` : appName),
    resolve: (name) =>
        resolvePageComponent(
            `./pages/${resolveFastPageName(name)}.vue`,
            import.meta.glob<DefineComponent>('./pages/**/*.vue'),
        ),
    setup({ el, App, props, plugin }) {
        createApp({ render: () => h(App, props) })
            .use(plugin)
            .mount(el);
    },
    progress: {
        color: '#4B5563',
    },
});

initializeTheme();
