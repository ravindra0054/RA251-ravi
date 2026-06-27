<?php
/**
 * Local theme registration
 */
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::THEME,
    'frontend/Local/my-app',
    __DIR__
);