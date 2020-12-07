$modelname "au_skeld/storage_barrel.mdl"
$body storage_barrel "storage_barrel.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "storage_barrel"

$collisionmodel "storage_barrel_phys.smd"
{
	$mass 10
	$concave
}
