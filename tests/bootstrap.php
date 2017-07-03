<?php

use Symfony\Component\Dotenv\Dotenv;

require '/composer/vendor/autoload.php';

$dotenv = new Dotenv();
$dotenv->load(dirname(__DIR__) . '/.env');
