<?php

namespace App\Tests\Composer;

use PHPUnit\Framework\TestCase;

class AutoloadTest extends TestCase
{
    /**
     * Autoload file must exist
     */
    public function testComposerAutoload()
    {
        $this->assertTrue(
            file_exists("/composer/vendor/autoload.php")
        );
    }
}
