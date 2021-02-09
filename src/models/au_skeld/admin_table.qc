$modelname "au_skeld/admin_table.mdl"
$body admin_table "admin_table.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "admin_table"

$collisionmodel "admin_table_phys.smd"
{
	$mass 250
	$concave
}
