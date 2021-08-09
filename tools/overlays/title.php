<?php 

parse_str(implode('&', array_slice($argv, 1)), $_GET);

?>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>timesnap</title>
    <style type="text/css" media="screen">
* {
  background: none;
  margin: 0;
  padding: 0;
}
body {
  width: 100vw;
  height: 100vh;
  color: #C90;
  display: flex;
  flex-flow: column nowrap;
  justify-content: center;
  align-items: center;
  font-family: "Fira Sans";
}
h1 {
  font-size: 4em;
  padding: 2em;
}
    </style>
  </head>
  <body>
    <h1><?= $_GET['title'] ?></h1>
  </body>
</html>
