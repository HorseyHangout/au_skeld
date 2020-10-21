$modelname "au_skeld/cafeteria_table.mdl"
$body cafeteria_table "cafeteria_table.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$texturegroup skinfamilies
{
	{ "cafeteria_table"  } //Skin 0
	{ "cafeteria_table_emergency" } //Skin 1
}
$sequence idle "cafeteria_table"

$collisionmodel "cafeteria_table_phys.smd"
{
	$mass 250
	$concave
}
