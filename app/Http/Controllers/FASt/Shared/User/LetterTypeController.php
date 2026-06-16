<?php

namespace App\Http\Controllers\FASt\Shared\User;

use App\Http\Controllers\Controller;
use App\Models\JenisSurat;
use App\Support\SuratDataContract;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class LetterTypeController extends Controller
{
    public function show(Request $request, JenisSurat $jenisSurat): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 403);
        abort_if(! $jenisSurat->is_active || $jenisSurat->template === null, 404);
        abort_unless($this->canAccessJenisSurat($user, $jenisSurat), 404);

        return response()->json([
            'data' => [
                'id' => $jenisSurat->id,
                'nama' => $jenisSurat->nama,
                'deskripsi' => $jenisSurat->deskripsi,
                'field_config' => SuratDataContract::normalizeDynamicFieldConfig(
                    SuratDataContract::filterDynamicFieldConfig($jenisSurat->field_config ?? []),
                ),
            ],
        ]);
    }

    protected function canAccessJenisSurat($user, JenisSurat $jenisSurat): bool
    {
        $user->loadMissing('role');

        $roleId = $user->role?->id;

        if (method_exists($user, 'isLab') && method_exists($user, 'isSekfak') && ($user->isLab() || $user->isSekfak())) {
            return (int) $jenisSurat->allowed_role_id === (int) $roleId;
        }

        if ($roleId === null) {
            return false;
        }

        return $jenisSurat->allowed_role_id === null || (int) $jenisSurat->allowed_role_id === (int) $roleId;
    }

}
