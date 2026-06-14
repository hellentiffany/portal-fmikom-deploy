<?php

namespace App\Http\Controllers\FASt\Sekfak;

use App\Http\Controllers\FASt\Shared\User\DashboardController as BaseDashboardController;

class DashboardController extends BaseDashboardController
{
    protected function pageName(): string
    {
        return 'sekfak/Dashboard';
    }

    protected function submissionRouteName(): string
    {
        return 'sekfak.submissions.store';
    }

    protected function basePath(): string
    {
        return '/sekfak';
    }
}
