$modelname "au_skeld/weapons_rail.mdl"
$body weapons_rail "weapons_rail.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "weapons_rail"

$collisionmodel "weapons_rail_phys.smd"
{
	$concave
	$maxconvexpieces 72
	$mass 100
}