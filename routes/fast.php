<?php

use App\Http\Controllers\FASt\Shared\Approval\ApprovalController as ApprovalDashboardController;
use App\Http\Controllers\FASt\Admin\ArchiveController;
use App\Http\Controllers\FASt\Admin\CategoryController;
use App\Http\Controllers\FASt\Admin\DashboardController;
use App\Http\Controllers\FASt\Admin\GlobalSettingsController;
use App\Http\Controllers\FASt\Admin\HistoryController;
use App\Http\Controllers\FASt\Admin\LetterController;
use App\Http\Controllers\FASt\Admin\LetterIndexController;
use App\Http\Controllers\FASt\Admin\QrManageController;
use App\Http\Controllers\FASt\Admin\TemplateController;
use App\Http\Controllers\FASt\NotificationController;
use App\Http\Controllers\Api\SuratController as ApiSuratController;
use App\Http\Controllers\FASt\Dekan\ApprovalController as DekanApprovalController;
use App\Http\Controllers\FASt\Mahasiswa\DashboardController as MahasiswaDashboardController;
use App\Http\Controllers\FASt\Mahasiswa\HistoryController as MahasiswaHistoryController;
use App\Http\Controllers\FASt\Mahasiswa\LetterTypeController as MahasiswaLetterTypeController;
use App\Http\Controllers\FASt\Mahasiswa\SubmissionController as MahasiswaSubmissionController;
use App\Http\Controllers\FASt\Kaprodi\ApprovalController as KaprodiApprovalController;
use App\Http\Controllers\FASt\Dosen\DashboardController as DosenDashboardController;
use App\Http\Controllers\FASt\Dosen\HistoryController as DosenHistoryController;
use App\Http\Controllers\FASt\Dosen\LetterTypeController as DosenLetterTypeController;
use App\Http\Controllers\FASt\Dosen\SubmissionController as DosenSubmissionController;
use App\Http\Controllers\FASt\Lab\DashboardController as LabDashboardController;
use App\Http\Controllers\FASt\Lab\HistoryController as LabHistoryController;
use App\Http\Controllers\FASt\Lab\SubmissionController as LabSubmissionController;
use App\Http\Controllers\FASt\Sekfak\DashboardController as SekfakDashboardController;
use App\Http\Controllers\FASt\Sekfak\HistoryController as SekfakHistoryController;
use App\Http\Controllers\FASt\Sekfak\SubmissionController as SekfakSubmissionController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Dokumen surat
|--------------------------------------------------------------------------
*/
$documentRoutes = function (): void {
     Route::get('/surat/{id}/template-preview', [DashboardController::class, 'previewTemplate'])
         ->whereNumber('id')
         ->name('surat.template-preview');
     Route::get('/surat/{id}/generated-document', [DashboardController::class, 'previewGeneratedDocument'])
         ->whereNumber('id')
         ->name('surat.generated-document');
     Route::get('/surat/{id}/generate', [LetterController::class, 'generate'])
         ->whereNumber('id')
         ->name('surat.generate');
     Route::get('/surat/{id}/pdf', [DashboardController::class, 'downloadPdf'])
         ->whereNumber('id')
         ->name('surat.pdf');
     Route::get('/lampiran/{id}/preview', [DashboardController::class, 'previewAttachment'])
         ->whereNumber('id')
         ->name('lampiran.preview');
 };

Route::middleware(['auth', 'verified'])
    ->prefix('documents')
    ->name('documents.')
    ->group($documentRoutes);

Route::middleware(['auth', 'verified'])
    ->group(function (): void {
        Route::post('/notifications/{notificationId}/read', [NotificationController::class, 'read'])
            ->name('notifications.read');
        Route::post('/notifications/read-all', [NotificationController::class, 'readAll'])
            ->name('notifications.read-all');
    });

/*
|--------------------------------------------------------------------------
| Alias kompatibilitas lama untuk dokumen admin
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified'])
    ->prefix('admin')
    ->name('admin.')
    ->group($documentRoutes);

/*
|--------------------------------------------------------------------------
| Legacy alias /fast/user/*
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified', 'fast.user'])
    ->prefix('fast/user')
    ->name('fast.user.')
    ->group(function (): void {
        Route::redirect('/', '/fast/user/dashboard')->name('index');
        Route::get('/dashboard', [MahasiswaDashboardController::class, 'index'])
            ->name('dashboard');
        Route::get('/ajukan', [MahasiswaSubmissionController::class, 'create'])
            ->name('ajukan');
        Route::post('/submissions', [MahasiswaSubmissionController::class, 'store'])
            ->name('submissions.store');
        Route::get('/history', [MahasiswaHistoryController::class, 'index'])
            ->name('history');
        Route::get('/history/{id}', [MahasiswaHistoryController::class, 'show'])
            ->whereNumber('id')
            ->name('history.show');
        Route::post('/surat/{id}/cancel', [MahasiswaHistoryController::class, 'cancel'])
            ->whereNumber('id')
            ->name('surat.cancel');
    });

/*
|--------------------------------------------------------------------------
| Mahasiswa dan dosen
|--------------------------------------------------------------------------
*/
$userRoutes = function (
    string $prefix,
    string $dashboardController,
    string $submissionController,
    string $historyController,
): void {
    Route::redirect('/', "/{$prefix}/dashboard")->name('index');
    Route::get('/dashboard', [$dashboardController, 'index'])
        ->name('dashboard');
    Route::get('/ajukan', [$submissionController, 'create'])
        ->name('ajukan');
    Route::post('/submissions', [$submissionController, 'store'])
        ->name('submissions.store');
    Route::get('/history', [$historyController, 'index'])
        ->name('history');
    Route::get('/history/{id}', [$historyController, 'show'])
        ->whereNumber('id')
        ->name('history.show');
    Route::post('/surat/{id}/cancel', [$historyController, 'cancel'])
        ->whereNumber('id')
        ->name('surat.cancel');
};

Route::middleware(['auth', 'verified', 'fast.user'])->group(function () use ($userRoutes): void {
    Route::prefix('mahasiswa')
        ->name('mahasiswa.')
        ->group(function () use ($userRoutes): void {
            $userRoutes(
                'mahasiswa',
                MahasiswaDashboardController::class,
                MahasiswaSubmissionController::class,
                MahasiswaHistoryController::class,
            );
        });

    Route::prefix('dosen')
        ->name('dosen.')
        ->group(function () use ($userRoutes): void {
            $userRoutes(
                'dosen',
                DosenDashboardController::class,
                DosenSubmissionController::class,
                DosenHistoryController::class,
            );
        });

    Route::prefix('lab')
        ->name('lab.')
        ->group(function () use ($userRoutes): void {
            $userRoutes(
                'lab',
                LabDashboardController::class,
                LabSubmissionController::class,
                LabHistoryController::class,
            );
        });

    Route::prefix('sekfak')
        ->name('sekfak.')
        ->group(function () use ($userRoutes): void {
            $userRoutes(
                'sekfak',
                SekfakDashboardController::class,
                SekfakSubmissionController::class,
                SekfakHistoryController::class,
            );
        });

    Route::get('/jenis-surat/{jenisSurat}', [MahasiswaLetterTypeController::class, 'show'])
        ->name('jenis-surat.show');

    Route::prefix('dosen')
        ->name('dosen.')
        ->group(function (): void {
            Route::get('/jenis-surat/{jenisSurat}', [DosenLetterTypeController::class, 'show'])
                ->name('jenis-surat.show');
        });
});

/*
|--------------------------------------------------------------------------
| Admin only
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified', 'admin.access'])
    ->prefix('admin')
    ->name('admin.')
    ->group(function (): void {
        Route::get('/dashboard', [DashboardController::class, 'index'])
            ->name('dashboard');
        Route::get('/archive', [ArchiveController::class, 'index'])
            ->name('archive.index');
        Route::get('/surat/{id}', [DashboardController::class, 'show'])
            ->whereNumber('id')
            ->name('surat.show');

        Route::get('/surat/create', [LetterController::class, 'create'])
            ->name('surat.create');
        Route::post('/surat/select-type', [LetterController::class, 'selectType'])
            ->name('surat.select-type');
        Route::get('/surat/form/{jenisSurat}', [LetterController::class, 'form'])
            ->name('surat.form');
        Route::get('/surat/preview', [LetterController::class, 'previewPage'])
            ->name('surat.preview-page');
        Route::post('/surat/preview', [LetterController::class, 'preview'])
            ->name('surat.preview');
        Route::post('/surat/store', [LetterController::class, 'store'])
            ->name('surat.store');

        Route::get('/surat', [LetterIndexController::class, 'index'])
            ->name('surat.index');
        Route::get('/surat/{id}/edit', [LetterController::class, 'edit'])
            ->whereNumber('id')
            ->name('surat.edit');
        Route::patch('/surat/{id}', [LetterController::class, 'update'])
            ->whereNumber('id')
            ->name('surat.update');
        Route::post('/surat/{id}/approve', [DashboardController::class, 'approve'])
            ->whereNumber('id')
            ->name('surat.approve');
        Route::post('/surat/{id}/reject', [DashboardController::class, 'reject'])
            ->whereNumber('id')
            ->name('surat.reject');

        Route::get('/history', [HistoryController::class, 'index'])
            ->name('history');

        Route::get('/templates', [TemplateController::class, 'index'])
            ->name('templates.index');
        Route::post('/templates', [TemplateController::class, 'store'])
            ->name('templates.store');
        Route::get('/templates/{jenisSurat}/preview', [TemplateController::class, 'preview'])
            ->name('templates.preview');
        Route::post('/templates/{jenisSurat}/duplicate', [TemplateController::class, 'duplicate'])
            ->name('templates.duplicate');
        Route::patch('/templates/{jenisSurat}/toggle-active', [TemplateController::class, 'toggleActive'])
            ->name('templates.toggle-active');
        Route::put('/templates/{jenisSurat}', [TemplateController::class, 'update'])
            ->name('templates.update');
        Route::delete('/templates/{jenisSurat}', [TemplateController::class, 'destroy'])
            ->name('templates.destroy');

        Route::get('/categories', [CategoryController::class, 'index'])
            ->name('categories.index');
        Route::post('/categories', [CategoryController::class, 'store'])
            ->name('categories.store');
        Route::put('/categories/{category}', [CategoryController::class, 'update'])
            ->name('categories.update');
        Route::delete('/categories/{category}', [CategoryController::class, 'destroy'])
            ->name('categories.destroy');

        Route::get('/qr', [QrManageController::class, 'index'])
            ->name('qr.index');
        Route::post('/qr/{id}/revoke', [QrManageController::class, 'revoke'])
            ->whereNumber('id')
            ->name('qr.revoke');

        Route::post('/settings/template', [GlobalSettingsController::class, 'save'])
            ->name('settings.template');
    });

/*
|--------------------------------------------------------------------------
|--------------------------------------------------------------------------
*/
$approvalRoutes = function (string $controller): void {
    Route::get('/dashboard', [$controller, 'index'])
        ->name('dashboard');
    Route::get('/antrian', [$controller, 'queue'])
        ->name('antrian');
    Route::get('/arsip', [$controller, 'archive'])
        ->name('arsip');
    Route::get('/surat/{id}/detail', [$controller, 'detail'])
        ->whereNumber('id')
        ->name('surat.detail');
    Route::get('/surat/{id}', [$controller, 'show'])
        ->whereNumber('id')
        ->name('surat.show');
    Route::get('/lampiran/{id}/preview', [$controller, 'previewAttachment'])
        ->whereNumber('id')
        ->name('lampiran.preview');
    Route::post('/surat/{id}/approve', [$controller, 'approve'])
        ->whereNumber('id')
        ->name('surat.approve');
    Route::post('/surat/{id}/reject', [$controller, 'reject'])
        ->whereNumber('id')
        ->name('surat.reject');
    Route::post('/surat/{id}/final-reject', [$controller, 'finalReject'])
        ->whereNumber('id')
        ->name('surat.final-reject');
    Route::post('/surat/{id}/note', [$controller, 'saveNote'])
        ->whereNumber('id')
        ->name('surat.note');
};

Route::middleware(['auth', 'verified', 'approval.access'])
    ->prefix('approval')
    ->name('approval.')
    ->group(function () use ($approvalRoutes) {
        $approvalRoutes(ApprovalDashboardController::class);
    });

Route::middleware(['auth', 'verified', 'approval.access'])
    ->prefix('kaprodi')
    ->name('kaprodi.')
    ->group(function () use ($approvalRoutes) {
        $approvalRoutes(KaprodiApprovalController::class);
    });

Route::middleware(['auth', 'verified', 'approval.access'])
    ->prefix('dekan')
    ->name('dekan.')
    ->group(function () use ($approvalRoutes) {
        $approvalRoutes(DekanApprovalController::class);
    });

/*
|--------------------------------------------------------------------------
| API Fast
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified'])
    ->prefix('api/fast')
    ->name('api.fast.')
    ->group(function (): void {
        Route::get('/surat', [ApiSuratController::class, 'index'])
            ->name('surat.index');
        Route::post('/surat', [ApiSuratController::class, 'store'])
            ->name('surat.store');
        Route::get('/surat/{surat}', [ApiSuratController::class, 'show'])
            ->name('surat.show');
        Route::post('/surat/{surat}/admin-validation', [ApiSuratController::class, 'adminValidate'])
            ->middleware('admin.access')
            ->name('surat.admin-validation');
        Route::post('/surat/{surat}/approval', [ApiSuratController::class, 'approve'])
            ->middleware('approval.access')
            ->name('surat.approval');
        Route::post('/surat/{surat}/generate-document', [ApiSuratController::class, 'generateDocument'])
            ->middleware('admin.access')
            ->name('surat.generate-document');
    });
