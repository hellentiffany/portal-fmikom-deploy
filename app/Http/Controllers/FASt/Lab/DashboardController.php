<?php

namespace App\Http\Controllers\FASt\Lab;

use App\Http\Controllers\FASt\Shared\User\DashboardController as BaseDashboardController;

class DashboardController extends BaseDashboardController
{
    protected function pageName(): string
    {
        return 'lab/Dashboard';
    }

    protected function submissionRouteName(): string
    {
        return 'lab.submissions.store';
    }

    protected function basePath(): string
    {
        return '/lab';
    }
}
