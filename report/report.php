<?php
require_once __DIR__.'/vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;
include 'report/header.php';


$plugin = Yaml::parseFile('blueprints.yaml');
// echo $plugin["name"] . "\n";
h1( $plugin["name"] );

foreach(array_keys($plugin["form"]["fields"]) as $key){
    echo " - ".$key."\n";
}

show_folder("blueprints");
show_folder("templates");
show_folder("scss");
show_folder("assets");
show_folder("languages");
show_folder("scaffolds");

include 'report/footer.php';
	
function h1($str) {
  echo "\n";
  echo "# ".$str."\n";
}

function h2($str) {
  echo "\n";
  echo "## ".$str."\n";
}

function cmd_block($cmd){
  echo "\n";
  echo "```sh\n";
  echo shell_exec($cmd);
  echo "```\n";
}

function show_folder($folder){
  h1($folder);
  cmd_block("tree --dirsfirst --noreport $folder");

}
