<?php

require_once __DIR__.'/vendor/autoload.php';

use Symfony\Component\Finder\Finder;
use Symfony\Component\Yaml\Yaml;
include 'report/markdown.php';

$project = Yaml::parseFile('blueprints.yaml');
$current_dir=rtrim(shell_exec('basename $PWD'));

include 'report/header.php';

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
blueprintListFields( $project["form"] );

?>

Before configuring this plugin, you should copy the `user/plugins/<?= $current_dir ?>/<?= $current_dir ?>.yaml` to `user/config/plugins/<?= $current_dir ?>.yaml` and only edit that copy.

Here is the default configuration and an explanation of available options:

```yaml
<?php include "${current_dir}.yaml" ?>
```

Note that if you use the admin plugin, a file with your configuration, and named <?= $current_dir ?>.yaml will be saved in the `user/config/plugins/` folder once the configuration is saved in the admin.

<?php

$finder = new Finder();

if (file_exists("blueprints")) {
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
      printf( "### %s\n", $template_data["title"] );
      printf( "%s\n", $template );
      printf( "extends: %s\n", $template_data["@extends"]["type"] );
      printf( "fields:\n" );
      blueprintListFields( $template_data["form"]["fields"]["tabs"] );
      // foreach(array_keys($template_data["form"]["fields"]["tabs"]["fields"]) as $key){
        // printf( "     - %s\n", $key );
      // }
    }
  }
}
show_folder("templates");
show_folder("scaffolds");
show_folder("scss");
show_folder("assets");
show_folder("languages");

	

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
