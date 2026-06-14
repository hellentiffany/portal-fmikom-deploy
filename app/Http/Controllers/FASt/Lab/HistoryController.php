<?php

namespace App\Http\Controllers\FASt\Lab;

use App\Http\Controllers\FASt\Shared\User\HistoryController as BaseHistoryController;

class HistoryController extends BaseHistoryController
{
    protected function pageName(): string
    {
        return 'lab/History';
    }

    protected function basePath(): string
    {
        return '/lab';
    }
}
