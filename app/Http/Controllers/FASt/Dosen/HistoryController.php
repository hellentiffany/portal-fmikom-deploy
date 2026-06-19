<?php

namespace App\Http\Controllers\FASt\Dosen;

use App\Modules\Fast\Controllers\Shared\User\HistoryController as BaseHistoryController;

class HistoryController extends BaseHistoryController
{
    protected function pageName(): string
    {
        return 'dosen/History';
    }

    protected function basePath(): string
    {
        return '/dosen';
    }
}
