<?php

namespace App\Http\Controllers\FASt\Lab;

use App\Http\Controllers\FASt\Shared\User\SubmissionController as BaseSubmissionController;

class SubmissionController extends BaseSubmissionController
{
    protected function pageName(): string
    {
        return 'lab/Ajukan';
    }

    protected function basePath(): string
    {
        return '/lab';
    }

    protected function dashboardRouteName(): string
    {
        return 'lab.dashboard';
    }
}
