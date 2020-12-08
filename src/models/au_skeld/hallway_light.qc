$modelname "au_skeld/hallway_light.mdl"
$body hallway_light "hallway_light.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "hallway_light"

$collisionmodel "hallway_light_phys.smd"
{
	$mass 10
	$concave
}
