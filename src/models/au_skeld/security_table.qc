$modelname "au_skeld/security_table.mdl"
$body security_table "security_table.smd"
$surfaceprop wood
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "security_table"

$collisionmodel "security_table_phys.smd"
{
	$mass 25
	$concave
}
