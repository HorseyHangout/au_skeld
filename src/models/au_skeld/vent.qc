$modelname "au_skeld/vent.mdl"
$body vent "vent.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "vent"

$collisionmodel "vent_phys.smd"
{
	$mass 1
	$concave
}
