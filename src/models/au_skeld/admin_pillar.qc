$modelname "au_skeld/admin_pillar"
$body admin_pillar "admin_pillar.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_pillar"

$collisionmodel "admin_pillar_phys.smd"
{
	$mass 250
	$concave
}
