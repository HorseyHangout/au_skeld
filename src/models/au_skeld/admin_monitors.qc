$modelname "au_skeld/admin_monitors"
$body admin_monitors "admin_monitors.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_monitors"

$collisionmodel "admin_monitors_phys.smd"
{
	$mass 900
	$concave
}
