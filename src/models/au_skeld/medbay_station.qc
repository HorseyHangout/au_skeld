$modelname "au_skeld/medbay_station.mdl"
$body medbay_station "medbay_station.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "medbay_station"

$collisionmodel "medbay_station_phys.smd"
{
	$mass 150
	$concave
}
