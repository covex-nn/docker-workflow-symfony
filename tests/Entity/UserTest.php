<?php

namespace App\Tests\Entity;

use App\Entity\User;
use PHPUnit\Framework\TestCase;

class UserTest extends TestCase
{
    /**
     * Autoload file must exist
     */
    public function testComposerAutoload()
    {
        $user = new User();
        $user->setRoles(['ROLE_ONE','ROLE_TWO',User::ROLE_DEFAULT]);

        $this->assertEquals('ROLE_ONE, ROLE_TWO', $user->getRolesAsString());
    }
}
