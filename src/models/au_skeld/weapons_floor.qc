$modelname "au_skeld/weapons_floor.mdl"
$body weapons_floor "weapons_floor.smd"
$surfaceprop concrete
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "weapons_floor"

$collisionmodel "weapons_floor_phys.smd"
{
	$mass 230
	$concave
}
