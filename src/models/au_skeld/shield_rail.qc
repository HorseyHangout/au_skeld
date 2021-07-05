$modelname "au_skeld/shield_rail.mdl"
$body shield_rail "shield_rail.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "shield_rail"

$collisionmodel "shield_rail_phys.smd"
{
	$concave
	$maxconvexpieces 90
	$mass 100
}