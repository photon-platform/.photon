<?php 

parse_str(implode('&', array_slice($argv, 1)), $_GET);

?>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>timesnap</title>
    <link href="../.photon/tools/overlays/overlay_right.css" type="text/css" rel="stylesheet">
    <style type="text/css" media="screen">
    </style>
  </head>
  <body>
    <div><?= $_GET['title'] ?></div>
  </body>
</html>
