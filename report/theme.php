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

?>

- [Getting Started](#getting-started)
- [Articles in Pages](#articles-in-pages)
- [License](#license)

<?php

h1( "configuration" );

echo "blueprints.yaml\n";
echo "\n";
echo "fields:\n";
blueprintListFields( $project["form"] );
// foreach(array_keys($project["form"]["fields"]["columns"]["fields"]) as $key){
    // echo "- ".$key."\n";
// }

?>

Before configuring this theme, you should copy the `user/themes/<?= $current_dir ?>/<?= $current_dir ?>.yaml` to `user/config/themes/<?= $current_dir ?>.yaml` and only edit that copy.

Here is the default configuration and an explanation of available options:

```yaml
<?php include "${current_dir}.yaml" ?>
```

Note that if you use the admin theme, a file with your configuration, and named <?= $current_dir ?>.yaml will be saved in the `user/config/themes/` folder once the configuration is saved in the admin.

<?php

$finder = new Finder();

if (file_exists("blueprints")) {
  show_folder("blueprints");
  $finder->files()->depth('== 0')->in("blueprints")->name("*.yaml");

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
show_folder("css");
show_folder("js");
show_folder("languages");
show_folder("font");

// include( "LICENSE.txt" );

?>

## Installation

- all photon themes are installed as git submodules. More on that later.

## Usage

Select template type when creating a new page

## Credits


## To Do

- [ ] Future plans, if any




**TOC**
<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->


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
