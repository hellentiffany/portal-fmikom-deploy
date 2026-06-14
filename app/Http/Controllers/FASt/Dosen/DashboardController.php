<?php

namespace App\Http\Controllers\FASt\Dosen;

use App\Http\Controllers\FASt\Shared\User\DashboardController as BaseDashboardController;

class DashboardController extends BaseDashboardController
{
    protected function pageName(): string
    {
        return 'dosen/Dashboard';
    }

    protected function submissionRouteName(): string
    {
        return 'dosen.submissions.store';
    }

    protected function basePath(): string
    {
        return '/dosen';
    }
}
