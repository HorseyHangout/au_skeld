$modelname "au_skeld/divert_power.mdl"
$body divert_power "divert_power.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$mostlyopaque

$sequence idle "divert_power"

$collisionmodel "divert_power_phys.smd"
{
	$mass 1.3
	$concave
}
