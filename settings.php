<?php

return [
    // Change this in your project
    'secret' => [
        'salt' => "Li8.1Ej2-<Cid3[bE",
    ],

    // Connection to DB settings
    'doctrine' => [
        'connection' => [
            'driver' => 'pdo_sqlite',
            'path' => VAR_DIR . '/database.sqlite',
        ],
    ],

    // App settings
    'settings' => [
        'displayErrorDetails' => true, // set to false in production
    ],
];
