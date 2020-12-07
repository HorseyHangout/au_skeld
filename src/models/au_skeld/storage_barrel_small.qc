$modelname "au_skeld/storage_barrel_small.mdl"
$body storage_barrel_small "storage_barrel_small.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "storage_barrel_small"

$collisionmodel "storage_barrel_small_phys.smd"
{
	$mass 6
	$concave
}
