$modelname "au_skeld/shield_floor.mdl"
$body shield_floor "shield_floor.smd"
$surfaceprop concrete
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "shield_floor"

$collisionmodel "shield_floor_phys.smd"
{
	$mass 230
	$concave
}
