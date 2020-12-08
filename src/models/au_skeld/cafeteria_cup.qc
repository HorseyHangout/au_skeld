$modelname "au_skeld/cafeteria_cup.mdl"
$body cafeteria_cup "cafeteria_cup.smd"
$surfaceprop papercup
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "cafeteria_cup"

$collisionmodel "cafeteria_cup_phys.smd"
{
	$mass 0.01
	$concave
}
