<?php 

//requires $project (project blueprint yaml) to be set in parent
?>
<a href="https://photon-platform.net/">
    <img src="https://photon-platform.net/user/images/photon-logo-banner.png" alt="photon" title="photon" align="right" height="120" />
</a>

<?php 
h1( $project["name"] );
h2( $project["version"] );

// ![GitHub release](https://img.shields.io/github/v/tag/photon-platform/grav-theme-photon)
?>

---


<?php

printf( "> %s\n", $project["description"]);
echo "\n";
