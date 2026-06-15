<?php

namespace App\Http\Controllers\FASt;

use App\Http\Controllers\Controller;
use App\Models\FastNotification;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class NotificationController extends Controller
{
    public function read(Request $request, string $notificationId): RedirectResponse
    {
        $user = $request->user();
        abort_if($user === null, 403);

        if (Schema::hasTable('fast_notifications')) {
            $notification = FastNotification::query()
                ->whereKey($notificationId)
                ->where('user_id', $user->id)
                ->firstOrFail();

            if ($notification->read_at === null) {
                $notification->forceFill(['read_at' => now()])->save();
            }
        }

        $redirectTo = $request->string('redirect_to')->trim()->toString();
        if ($redirectTo !== '' && Str::startsWith($redirectTo, '/')) {
            return redirect()->to($redirectTo);
        }

        return back();
    }
}
