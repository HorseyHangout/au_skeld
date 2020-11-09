$modelname "au_skeld/lever.mdl"
$body lever "lever.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "lever"

$collisionmodel "lever_phys.smd"
{
	$mass 20
	$concave
}
