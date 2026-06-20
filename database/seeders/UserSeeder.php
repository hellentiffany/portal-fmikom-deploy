<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Role;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Get roles as [slug => Role]
        $roles = Role::query()->get(['id', 'slug', 'nama'])->keyBy('slug');

        foreach ($roles as $slug => $role) {
            $email = sprintf('%s@example.com', $slug);
            $name = sprintf('%s User', ucfirst($slug));
            $userType = $slug === 'admin' ? 'super_admin' : $slug;

            $data = [
                'name' => $name,
                'role_title' => $role->nama ?? ucfirst($slug),
                'user_type' => $userType,
                'email_verified_at' => now(),
                'password' => Hash::make('password'),
                'remember_token' => Str::random(10),
                'role_id' => $role->id,
            ];

            // Add minimal identifiers for student/lecturer
            if (in_array($slug, ['mahasiswa', 'dosen'], true)) {
                $data['nim_nip'] = '2021' . str_pad((string) $role->id, 4, '0', STR_PAD_LEFT);
                $data['nomor_induk'] = $data['nim_nip'];
            }

            User::query()->updateOrCreate(
                ['email' => $email],
                $data,
            );
        }
    }
}
