$modelname "au_skeld/cafeteria_pizza.mdl"
$body cafeteria_pizza "cafeteria_pizza.smd"
$surfaceprop plastic
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "cafeteria_pizza"

$collisionmodel "cafeteria_pizza_phys.smd"
{
	$mass 0.150
	$concave
}
