<?php
require_once __DIR__.'/vendor/autoload.php';


use Symfony\Component\Finder\Finder;
use Symfony\Component\Yaml\Yaml;
include 'report/header.php';

// TODO: assumes we are in a grav plugin or theme

$current_dir=rtrim(shell_exec('basename $PWD'));

$plugin = Yaml::parseFile('blueprints.yaml');
h1( $plugin["name"] );
h2( $plugin["version"] );
printf( "> %s\n", $plugin["description"]);

printf( '- [%1$s](#%1$s)'."\n", "configuration" );
printf( '- [%1$s](#%1$s)'."\n", "templates" );
printf( '- [%1$s](#%1$s)'."\n", "scaffolds" );
printf( '- [%1$s](#%1$s)'."\n", "scss" );
printf( '- [%1$s](#%1$s)'."\n", "assets" );
printf( '- [%1$s](#%1$s)'."\n", "languages" );

h1( "configuration" );
echo "blueprints.yaml\n";
echo "\n";
echo "fields:\n";
foreach(array_keys($plugin["form"]["fields"]) as $key){
    echo " - ".$key."\n";
}

?>

Before configuring this plugin, you should copy the `user/plugins/<?= $current_dir ?>/<?= $current_dir ?>.yaml` to `user/config/plugins/<?= $current_dir ?>.yaml` and only edit that copy.

Here is the default configuration and an explanation of available options:

Note that if you use the admin plugin, a file with your configuration, and named <?= $current_dir ?>.yaml will be saved in the `user/config/plugins/` folder once the configuration is saved in the admin.

<?php

$finder = new Finder();

if (file_exists($folder)) {
  show_folder("blueprints");
  $finder->files()->depth('== 0')->in("blueprints")->name("*.yaml");

  // check if there are any search results
  if ($finder->hasResults()) {
    // echo $finder->count()." files found\n";
    foreach ($finder as $file) {
      // $absoluteFilePath = $file->getRealPath();
      $template = $file->getRelativePathname();
      $template_data = Yaml::parseFile($file);
      echo "\n";
      printf( "- %s\n", $template_data["title"] );
      printf( "    %s\n", $template );
      printf( "    extends: %s\n", $template_data["@extends"]["type"] );
      printf( "    fields:\n" );
      foreach(array_keys($template_data["form"]["fields"]["tabs"]["fields"]) as $key){
        printf( "     - %s\n", $key );
      }
    }
  }
}
show_folder("templates");
show_folder("scaffolds");
show_folder("scss");
show_folder("assets");
show_folder("languages");

	
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
  if (file_exists($folder)) {
    h1($folder);
    cmd_block("tree --dirsfirst --noreport $folder");
    $filename = $folder.'/README.md';

    if (file_exists($filename)) {
      include( $filename );
    }
  }

}

// include( "LICENSE.txt" );


?>


## Installation

- all photon plugins are installed as git submodules. More on that later.



## Configuration


## Usage

Select template type when creating a new page

## Credits


## To Do

- [ ] Future plans, if any

<?php
include 'report/footer.php';
