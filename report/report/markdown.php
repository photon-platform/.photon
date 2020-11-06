<?php

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

function blueprintListFields($bp, $indent = "" )
{
  if ( $bp["fields"] ) {
    foreach(array_keys($bp["fields"]) as $key){
      echo $indent."- ".$key."\n";
      blueprintListFields( $bp["fields"][$key], $indent."  " );
    }
  }
  
}

