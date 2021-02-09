$modelname "au_skeld/admin_table_cardswipe.mdl"
$body admin_table_cardswipe "admin_table_cardswipe.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_table_cardswipe"

$collisionmodel "admin_table_cardswipe_phys.smd"
{
	$mass 50
	$concave
}
