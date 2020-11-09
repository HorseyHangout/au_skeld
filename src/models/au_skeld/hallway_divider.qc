$modelname "au_skeld/hallway_divider.mdl"
$body hallway_divider "hallway_divider.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "hallway_divider"

$collisionmodel "hallway_divider_phys.smd"
{
	$mass 50
	$concave
}
