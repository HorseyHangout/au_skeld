$modelname "au_skeld/security_station.mdl"
$body security_station "security_station.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "security_station"

$collisionmodel "security_station_phys.smd"
{
	$mass 150
	$concave
}
