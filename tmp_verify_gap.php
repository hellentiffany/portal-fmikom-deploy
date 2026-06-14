<?php
require 'vendor/autoload.php';
$app = require 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
$svc = app(App\Services\SuratDocumentGeneratorService::class);
$surat = App\Models\Surat::query()->with(['jenisSurat.template.placeholders', 'pemohon', 'dataEntries'])->findOrFail(210);
$generated = $svc->generate($surat);
echo $generated->generated_file_path;
