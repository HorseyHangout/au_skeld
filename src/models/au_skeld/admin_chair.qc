$modelname "au_skeld/admin_chair"
$body admin_chair "admin_chair.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_chair"

$collisionmodel "admin_chair_phys.smd"
{
	$mass 5
	$concave
}
