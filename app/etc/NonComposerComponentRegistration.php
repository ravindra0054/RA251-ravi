<?php
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */

/**
 * This file is used for registering components that are not installed via Composer
 */

// Register modules that are not installed via Composer
$registrationFiles = glob(__DIR__ . '/../../app/code/*/*/registration.php');
foreach ($registrationFiles as $file) {
    include $file;
}