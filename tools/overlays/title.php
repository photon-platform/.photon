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
  width: 1920px;
  height: 1080px;
  color: #C90;
  display: flex;
  flex-flow: column nowrap;
  justify-content: center;
  align-items: center;
  font-family: "Fira Sans";
  background: url("../Sessions/smolen/title/wall.jpg");
}
h1 {
  text-align: center;
  font-size: 100px;
  color: white;
  text-shadow: 2px 2px 4px #000000;
  padding: 2em;
  font-weight: 400;
}
    </style>
  </head>
  <body>
    <h1><?= $_GET['title'] ?></h1>
  </body>
</html>
