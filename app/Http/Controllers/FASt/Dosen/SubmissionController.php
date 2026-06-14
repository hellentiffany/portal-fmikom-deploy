<?php

namespace App\Http\Controllers\FASt\Dosen;

use App\Http\Controllers\FASt\Shared\User\SubmissionController as BaseSubmissionController;

class SubmissionController extends BaseSubmissionController
{
    protected function pageName(): string
    {
        return 'dosen/Ajukan';
    }

    protected function basePath(): string
    {
        return '/dosen';
    }

    protected function dashboardRouteName(): string
    {
        return 'dosen.dashboard';
    }
}
