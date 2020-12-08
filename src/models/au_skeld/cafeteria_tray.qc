$modelname "au_skeld/cafeteria_tray.mdl"
$body cafeteria_tray "cafeteria_tray.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "cafeteria_tray"

$collisionmodel "cafeteria_tray_phys.smd"
{
	$mass 1
	$concave
}
