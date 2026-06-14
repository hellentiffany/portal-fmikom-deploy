<?php
require 'vendor/autoload.php';
$app = require 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
$surat = App\Models\Surat::query()->with(['dataEntries'])->findOrFail(210);
foreach ($surat->dataEntries as $entry) {
    echo $entry->field_name . ' = ' . $entry->field_value . PHP_EOL;
}
