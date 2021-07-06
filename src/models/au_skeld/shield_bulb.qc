$modelname "au_skeld/shield_bulb.mdl"
$body shield_bulb "shield_bulb.smd"
$surfaceprop glass
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$mostlyopaque

$sequence idle "shield_bulb"

$collisionmodel "shield_bulb_phys.smd"
{
	$mass 150
	$concave
}
