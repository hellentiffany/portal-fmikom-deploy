<?php

namespace App\Http\Controllers\FASt\Sekfak;

use App\Http\Controllers\FASt\Shared\User\HistoryController as BaseHistoryController;

class HistoryController extends BaseHistoryController
{
    protected function pageName(): string
    {
        return 'sekfak/History';
    }

    protected function basePath(): string
    {
        return '/sekfak';
    }
}
