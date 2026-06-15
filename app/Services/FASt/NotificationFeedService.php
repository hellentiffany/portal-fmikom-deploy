<?php

namespace App\Services\FASt;

use App\Models\FastNotification;
use App\Models\Surat;
use App\Models\User;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class NotificationFeedService
{
    /**
     * @return array{count: int, items: array<int, array<string, mixed>>}
     */
    public function build(User $user): array
    {
        $user->loadMissing('role');

        $roleSlug = Str::slug((string) ($user->role?->slug ?? ''));
        $items = match (true) {
            $roleSlug === 'admin' => $this->adminItems($user),
            in_array($roleSlug, ['kaprodi', 'dekan'], true) => $this->approverItems($user, $roleSlug),
            default => $this->requesterItems($user, $roleSlug),
        };

        if (! Schema::hasTable('fast_notifications')) {
            return [
                'count' => count($items),
                'items' => array_map(function (array $item): array {
                    return [
                        'id' => $item['notification_key'],
                        'notification_key' => $item['notification_key'],
                        'title' => $item['title'],
                        'message' => $item['message'],
                        'href' => $item['href'],
                        'time' => now()->toISOString(),
                        'tone' => $item['tone'],
                        'readAt' => null,
                    ];
                }, $items),
            ];
        }

        $this->sync($user, $items);

        $records = FastNotification::query()
            ->where('user_id', $user->id)
            ->whereIn('notification_key', array_column($items, 'notification_key'))
            ->orderByRaw('read_at is not null asc')
            ->orderByDesc('updated_at')
            ->limit(6)
            ->get();

        return [
            'count' => FastNotification::query()
                ->where('user_id', $user->id)
                ->whereNull('read_at')
                ->count(),
            'items' => $records->map(fn (FastNotification $notification): array => [
                'id' => $notification->id,
                'notification_key' => $notification->notification_key,
                'title' => $notification->title,
                'message' => $notification->message,
                'href' => $notification->href ?? '#',
                'time' => $notification->updated_at?->toISOString(),
                'tone' => $notification->tone,
                'readAt' => $notification->read_at?->toISOString(),
            ])->values()->all(),
        ];
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    protected function requesterItems(User $user, string $roleSlug): array
    {
        $basePath = $this->requesterBasePath($roleSlug);

        return Surat::query()
            ->with(['jenisSurat:id,nama'])
            ->where('pemohon_id', $user->id)
            ->where('updated_at', '>=', now()->subDays(30))
            ->latest('updated_at')
            ->latest('id')
            ->limit(6)
            ->get()
            ->map(function (Surat $surat) use ($basePath): array {
                [$message, $tone] = $this->requesterToneAndMessage($surat->status);

                return [
                    'scope' => 'requester',
                    'notification_key' => sprintf('requester:%d:%s', $surat->id, $surat->status),
                    'title' => $surat->jenisSurat?->nama ?? 'Surat Akademik',
                    'message' => $message,
                    'tone' => $tone,
                    'href' => sprintf('%s/history?status=%s', $basePath, $surat->status),
                    'meta' => [
                        'surat_id' => $surat->id,
                        'status' => $surat->status,
                    ],
                ];
            })
            ->values()
            ->all();
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    protected function approverItems(User $user, string $roleSlug): array
    {
        $basePath = '/' . $roleSlug;

        return Surat::query()
            ->with([
                'jenisSurat:id,nama,approval_role_id',
                'jenisSurat.approvalRole:id,nama,slug',
                'pemohon:id,name,nim_nip,nomor_induk',
            ])
            ->where('status', Surat::STATUS_VALIDATED_ADMIN)
            ->whereHas('jenisSurat.approvalRole', function ($q) use ($roleSlug): void {
                $q->where(function ($nested) use ($roleSlug): void {
                    $nested->where('slug', 'like', "%{$roleSlug}%")
                        ->orWhere('nama', 'like', "%{$roleSlug}%");
                });
            })
            ->latest('updated_at')
            ->latest('id')
            ->limit(6)
            ->get()
            ->map(function (Surat $surat) use ($basePath, $roleSlug): array {
                $pemohon = $surat->pemohon?->name ?? 'Pemohon';
                $roleLabel = $roleSlug === 'kaprodi' ? 'Kaprodi' : 'Dekan';

                return [
                    'scope' => 'approver',
                    'notification_key' => sprintf('approver:%s:%d:%s', $roleSlug, $surat->id, $surat->status),
                    'title' => $surat->jenisSurat?->nama ?? 'Surat Akademik',
                    'message' => "Menunggu persetujuan {$roleLabel} dari {$pemohon}",
                    'tone' => 'amber',
                    'href' => sprintf('%s/surat/%d/detail?from=antrian', $basePath, $surat->id),
                    'meta' => [
                        'surat_id' => $surat->id,
                        'status' => $surat->status,
                        'role' => $roleSlug,
                    ],
                ];
            })
            ->values()
            ->all();
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    protected function adminItems(User $user): array
    {
        return Surat::query()
            ->with(['jenisSurat:id,nama', 'pemohon:id,name'])
            ->where(function ($q): void {
                $q->where('status', Surat::STATUS_PENDING)
                    ->orWhere(function ($nested): void {
                        $nested->where('type', 'surat_keluar')
                            ->where('status', Surat::STATUS_REVISION_REQUESTED);
                    });
            })
            ->latest('updated_at')
            ->latest('id')
            ->limit(6)
            ->get()
            ->map(function (Surat $surat): array {
                [$message, $tone] = $this->adminToneAndMessage($surat);

                return [
                    'scope' => 'admin',
                    'notification_key' => sprintf('admin:%d:%s', $surat->id, $surat->status),
                    'title' => $surat->jenisSurat?->nama ?? 'Surat Akademik',
                    'message' => $message,
                    'tone' => $tone,
                    'href' => sprintf('/admin/surat/%d', $surat->id),
                    'meta' => [
                        'surat_id' => $surat->id,
                        'status' => $surat->status,
                    ],
                ];
            })
            ->values()
            ->all();
    }

    /**
     * @param array<int, array<string, mixed>> $items
     */
    protected function sync(User $user, array $items): void
    {
        foreach ($items as $item) {
            FastNotification::query()->updateOrCreate(
                [
                    'user_id' => $user->id,
                    'notification_key' => $item['notification_key'],
                ],
                [
                    'scope' => $item['scope'],
                    'title' => $item['title'],
                    'message' => $item['message'],
                    'href' => $item['href'],
                    'tone' => $item['tone'],
                    'meta' => $item['meta'] ?? null,
                ],
            );
        }
    }

    protected function requesterBasePath(string $roleSlug): string
    {
        if ($roleSlug === 'dosen') {
            return '/dosen';
        }

        if ($roleSlug === 'lab') {
            return '/lab';
        }

        if ($roleSlug === 'sekfak' || Str::contains($roleSlug, 'sekretaris')) {
            return '/sekfak';
        }

        return '/mahasiswa';
    }

    /**
     * @return array{0: string, 1: string}
     */
    protected function requesterToneAndMessage(string $status): array
    {
        return match ($status) {
            Surat::STATUS_PENDING => ['Pengajuan baru dikirim dan menunggu validasi admin', 'amber'],
            Surat::STATUS_VALIDATED_ADMIN => ['Pengajuan sudah divalidasi admin', 'blue'],
            Surat::STATUS_REVISION_REQUESTED => ['Ada revisi yang perlu diperbaiki', 'amber'],
            Surat::STATUS_APPROVED_KAPRODI => ['Surat disetujui Kaprodi', 'green'],
            Surat::STATUS_APPROVED_DEKAN => ['Surat disetujui Dekan', 'green'],
            Surat::STATUS_FINISHED => ['Surat sudah selesai diproses', 'green'],
            Surat::STATUS_REJECTED_ADMIN => ['Pengajuan ditolak admin', 'rose'],
            Surat::STATUS_REJECTED_APPROVER => ['Pengajuan ditolak pada tahap akhir', 'rose'],
            Surat::STATUS_CANCELLED => ['Pengajuan dibatalkan', 'slate'],
            default => ['Status pengajuan diperbarui', 'slate'],
        };
    }

    /**
     * @return array{0: string, 1: string}
     */
    protected function adminToneAndMessage(Surat $surat): array
    {
        return match ($surat->status) {
            Surat::STATUS_PENDING => ['Menunggu validasi admin', 'amber'],
            Surat::STATUS_REVISION_REQUESTED => ['Perlu tindak lanjut revisi', 'amber'],
            default => ['Masuk daftar pemantauan admin', 'blue'],
        };
    }
}
