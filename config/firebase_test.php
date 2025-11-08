<?php

return [
    'credentials' => [
        'file' => base_path(env('FIREBASE_CREDENTIALS', 'storage/app/firebase/firebase_service.json')),
    ],
];