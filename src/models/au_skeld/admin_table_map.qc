$modelname "au_skeld/admin_table_map.mdl"
$body admin_table_map "admin_table_map.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_table_map"

$collisionmodel "admin_table_map_phys.smd"
{
	$mass 50
	$concave
}
