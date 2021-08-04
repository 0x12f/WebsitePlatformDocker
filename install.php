<?php

/**
 * CLI Install script
 * @author Aleksey Ilyin
 * @see https://github.com/getwebspace
 */

// get WSE tags list
$context = stream_context_create(['http' => ['method' => "GET", 'header' => "User-Agent: PHP\r\n" . "Accept-language: en\r\n"]]);
$result = file_get_contents("https://api.github.com/repos/getwebspace/platform/tags", false, $context);
$versions = array_slice(array_column(json_decode($result ?: '[]', true), 'name'), 0, 5);

// prepare params array
$params = [
    'dir' => __DIR__,
    'version' => $versions[0],
    'salt' => '',
    'simple_phone' => true,
    'domain' => '',
    'database' => '',
    'plugins' => [
        'cache' => false,
        'seo' => false,
        'tm' => false,
    ],
];

// start
cli_echo("Welcome to WebSpace Engine CLI Install script!", "\e[31m");
cli_echo("Author: Aleksey Ilyin", "\e[2m");
cli_echo("GitHub: https://github.com/getwebspace", "\e[2m");

cli_echo("");

// directory install
cli_echo("Install DIR (" . $params['dir'] . "): ");
$params['dir'] = cli_read() ?: $params['dir'];

// engine version
cli_echo("Engine version (" . $params['version'] . "): ");
$params['version'] = cli_read() ?: $params['version'];

// domain name
cli_echo("Domain name: ");
$params['domain'] = cli_read();

cli_echo("New random salt: ");
cli_echo($params['salt'] = str_random(), "\e[91m");

// simple phone
cli_echo("Use simple phone ? (Y|n): ");
$params['simple_phone'] = mb_strtolower(cli_read() ?: 'y') === 'y';

// dsn database
cli_echo("Enter DNS (eg: mysql://username:password@hostname/database): ");
$params['database'] = cli_read();

// finish
cli_echo("Params saved!" . PHP_EOL, "\e[92m");

// work
// create dir
if (!file_exists($params['dir'])) {
    mkdir($params['dir'], 0777, true);
}
if (is_dir($params['dir'])) {
    // clone from github
    cli_echo("Cloning..");
    @exec("git clone https://github.com/getwebspace/platform-template.git " . $params['dir']);
    cli_echo("Done!" . PHP_EOL, "\e[92m");

    // read yml file
    $yml = file_get_contents($params['dir'] . '/docker-compose.yml');

    // change version
    $yml = str_replace('latest', $params['version'], $yml);
    // change salt
    $yml = str_replace('# - SALT=Please-Change-Me', '  - SALT=' . $params['salt'], $yml);
    if ($params['simple_phone']) {
        // change simple_phone
        $yml = str_replace('# - SIMPLE_PHONE_CHECK=1', '  - SIMPLE_PHONE_CHECK=1', $yml);
    }
    // change database dsn
    $yml = str_replace('# - DATABASE=mysql://user:secret@localhost/mydb', '  - DATABASE=' . $params['database'], $yml);
    // change domain
    $yml = str_replace('Host(`example.com`)', 'Host(`' . $params['domain'] . '`)', $yml);
    // change traefik prefix
    $yml = str_replace('example', str_replace('.', '', $params['domain']), $yml);

    // write back
    file_put_contents($params['dir'] . '/docker-compose.yml', $yml);
    cli_echo("Docker-compose configured" . PHP_EOL, "\e[92m");

    // run
    cli_echo("Run container");
    @exec("cd ". $params['dir'] ." && docker-compose up -d");
} else {
    cli_echo("Install path (" . $params['dir'] . ") is not a directory", "\e[91m");
}

// functions
function str_random(): string
{
    $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    $pass = [];
    for ($i = 0; $i < 10; $i++) {
        $n = rand(0, strlen($alphabet) - 1);
        $pass[] = $alphabet[$n];
    }

    return implode($pass);
}

function cli_echo($text, $format = "\e[0m"): void
{
    echo $format . $text . PHP_EOL;
}

function cli_read(): string
{
    return rtrim(fgets(STDIN)) ?: false;
}
