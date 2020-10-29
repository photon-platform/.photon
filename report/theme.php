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





**TOC**
<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

* [Getting Started](#getting-started)
* [Articles in Pages](#articles-in-pages)
* [Templates](#templates)
* [Styles](#styles)
* [License](#license)

<!-- /code_chunk_output -->

![](screenshot.jpg)

## Getting Started
The best way to start with photon THEME is with a photon STARTER project. Checkout the repo here:

https://github.com/photon-platform/photon

Current version of this theme has some dependencies on  site level configurations. This will be resolved in a future version.

See the theme configuration section for more on the STARTER project:
https://github.com/photon-platform/photon#theme-configuration

I highly recommend reviewing the excellent material on GRAV Documentation site:
https://learn.getgrav.org/themes


## Articles in Pages

Photon takes a content first approach to development.

We develop our content as a set of hierarchical data.

An **Article** is a node in our dataset.

A **Page** is the template document that structures the content of one or more articles along with components to provide context and navigation.





## Templates
see README in templates folder for more about the concpets for the TWIG template files:

[`templates`](templates)


## Styles
see README in scss folder for more on the stylesheet development:

[`scss`](scss)



## License

See [LICENSE](LICENSE)
<?php
include 'report/footer.php';
