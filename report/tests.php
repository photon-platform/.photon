<?php
require_once __DIR__.'/vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;
use Symfony\Component\Console\Application;
use Symfony\Component\Finder\Finder;
include 'color.php';
include 'report/header.php';

$finder = new Finder();
// find all files in the current directory
$finder->files()->depth('== 0')->in(__DIR__)->name("*.php");

// check if there are any search results
if ($finder->hasResults()) {
  // echo "files found\n";
  foreach ($finder as $file) {
      // $absoluteFilePath = $file->getRealPath();
      // $fileNameWithExtension = $file->getRelativePathname();
      // printf ("%s\n", "$absoluteFilePath  - $fileNameWithExtension");
  }
}


// $application = new Application();

// ... register commands

// $application->run();

$value = Yaml::parseFile('blueprints.yaml');
// $value = ['foo' => 'bar']
// $yaml_str = file_get_contents('blueprints.yaml');
// $yaml = yaml_parse($yaml);
echo $value["name"] . "\n";
// echo $value["form"]["fields"][0] . "\n";
// var_dump($value);
foreach(array_keys($value["form"]["fields"]) as $key){
    echo " - ".$key."\n";
}

// $doc = new DOMDocument();
// $doc->loadHTML("<html><body>Test<br></body></html>");
// echo $doc->saveHTML();
// $json = '{"foo-bar": 12345}';

// $obj = json_decode($json);
// print $obj->{'foo-bar'}; // 12345

// print "input: ";
// $line = fgets(STDIN);
// printf ("%s\n", $line);

// $tmp = explode("\n", shell_exec('la'));
// print_r($tmp);

// $number = readline("Enter a number: ");
// echo 'You picked the number: '.$number;

// $colors = new Colors();

// Test some basic printing with Colors class
// echo $colors->getColoredString("Testing Colors class, this is purple string on yellow background.", "purple", "yellow") . "\n";
include 'report/footer.php';
	
