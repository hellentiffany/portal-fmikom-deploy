<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable, TwoFactorAuthenticatable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role_id',
        'program_studi_id',
        'nim_nip',
        'nomor_induk',
        'no_telepon',
        'foto_path',
        'is_active',
        'status_approval',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'two_factor_secret',
        'two_factor_recovery_codes',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'two_factor_confirmed_at' => 'datetime',
            'is_active' => 'boolean',
        ];
    }

    /**
     * @return BelongsTo<Role, $this>
     */
    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class);
    }

    /**
     * @return BelongsTo<ProgramStudi, $this>
     */
    public function programStudi(): BelongsTo
    {
        return $this->belongsTo(ProgramStudi::class);
    }

    public function hasFastUserRole(): bool
    {
        return $this->isMahasiswa()
            || $this->isDosen();
    }

    public function roleSlug(): string
    {
        $this->loadMissing('role');

        $slug = str((string) $this->role?->slug)->slug()->toString();

        if ($slug !== '') {
            return $slug;
        }

        return str((string) $this->role?->nama)->slug()->toString();
    }

    public function hasRole(string ...$roles): bool
    {
        $roleSlug = $this->roleSlug();

        return in_array($roleSlug, array_map(
            static fn (string $role): string => str($role)->slug()->toString(),
            $roles,
        ), true);
    }

    public function isAdmin(): bool
    {
        return $this->hasRole('admin');
    }

    public function isApprover(): bool
    {
        return $this->isKaprodi() || $this->isDekan();
    }

    public function isKaprodi(): bool
    {
        return str($this->roleSlug())->contains('kaprodi');
    }

    public function isDekan(): bool
    {
        return str($this->roleSlug())->contains('dekan');
    }

    public function isMahasiswa(): bool
    {
        $roleSlug = $this->roleSlug();

        return str($roleSlug)->contains('mahasiswa');
    }

    public function isDosen(): bool
    {
        $roleSlug = $this->roleSlug();

        return $roleSlug === 'lecturer'
            || str($roleSlug)->contains('dosen');
    }

    public function isLab(): bool
    {
        $roleSlug = $this->roleSlug();

        return str($roleSlug)->contains('lab');
    }

    public function isSekfak(): bool
    {
        $roleSlug = $this->roleSlug();

        return str($roleSlug)->contains('sekfak')
            || str($roleSlug)->contains('sekretaris');
    }

    public function hasStaffAccess(): bool
    {
        return $this->isAdmin() || $this->isApprover();
    }

    public function dashboardRouteName(): string
    {
        return match (true) {
            $this->isAdmin() => 'admin.dashboard',
            $this->isKaprodi() => 'kaprodi.dashboard',
            $this->isDekan() => 'dekan.dashboard',
            $this->isDosen() => 'dosen.dashboard',
            $this->isMahasiswa() => 'mahasiswa.dashboard',
            default => abort(403),
        };
    }
}
