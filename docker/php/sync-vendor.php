#!/usr/local/bin/php -dphar.readonly=0
<?php

$source = '/composer/vendor';
$target = '/srv/.sync';

if (is_file($target) && !is_dir($target)) {
    unlink($target);
}
if (!file_exists($target)) {
    mkdir($target, true);
}
if (file_exists($source) && is_dir($source)) {
    foreach (new DirectoryIterator($source) as $dir) {
        /* @var $dir DirectoryIterator */
        if (!$dir->isDot() && $dir->isDir()) {
            $pharName = $dir->getFilename();
            if (in_array($pharName, ["bin"])) {
                continue;
            }
            $pharAlias = $pharName . ".phar";
            $pharFilename = $target . "/" . $pharAlias;

            $phar = new Phar($pharFilename);
            try {
                $phar->buildFromDirectory($dir->getPathname());
                $phar->setStub(
                        '<?php /* ' . date("Y-m-d H:i:s") . ' */

if (file_exists("' . $pharName . '")) {
    if (is_file("' . $pharName . '")) {
        unlink("' . $pharName . '");
    } elseif (is_dir("' . $pharName . '")) {
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator("' . $pharName . '", FilesystemIterator::SKIP_DOTS),
            RecursiveIteratorIterator::CHILD_FIRST
        );
        foreach ($iterator as $filename => $fileInfo) {
            if ($fileInfo->isDir()) {
                rmdir($filename);
            } else {
                unlink($filename);
            }
        }
    }
}
if (!file_exists("' . $pharName . '")) {
    $phar = new Phar(__FILE__);
    $phar->extractTo("' . $pharName . '", null, true);
    unset($phar);
    unlink(__FILE__);
} else {
    echo "Could not extract PHAR. File \"' . $pharName . '\" exists" . PHP_EOL;
}
__HALT_COMPILER();
'
                );
                chmod($pharFilename, 0755);
                echo "Synced vendor $pharAlias\n";
            } catch (Exception $exception) {
                echo "Could not sync vendor $pharAlias: " . $exception->getMessage() . "\n";
            }
        }
    }
}
