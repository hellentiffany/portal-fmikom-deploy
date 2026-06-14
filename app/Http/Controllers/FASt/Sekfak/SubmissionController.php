<?php

namespace App\Http\Controllers\FASt\Sekfak;

use App\Http\Controllers\FASt\Shared\User\SubmissionController as BaseSubmissionController;

class SubmissionController extends BaseSubmissionController
{
    protected function pageName(): string
    {
        return 'sekfak/Ajukan';
    }

    protected function basePath(): string
    {
        return '/sekfak';
    }

    protected function dashboardRouteName(): string
    {
        return 'sekfak.dashboard';
    }
}
