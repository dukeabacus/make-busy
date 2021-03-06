<?php
require_once 'vendor/autoload.php';
$token = $argv[1];
list($owner, $repo, $commit, $pr) = explode(':', $argv[2]);
$state = $argv[3];
$short_sha = substr($commit, 0, 10);

$client = new \Github\Client();
$client->authenticate($token, null, Github\Client::AUTH_HTTP_TOKEN);
$re = $client->api('repo')->statuses()->create($owner, $repo, $commit,
[
	'target_url' => "http://docker.2600hz.com/status.php?ref=$short_sha&pr=$pr",
	'state' => $state,
	'context' => 'MakeBusy'
]);
