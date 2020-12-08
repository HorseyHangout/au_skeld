$modelname "au_skeld/emergency_button.mdl"
$body emergency_button "emergency_button.smd"
$surfaceprop glass
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$mostlyopaque

$sequence idle "emergency_button"

$collisionmodel "emergency_button_phys.smd"
{
	$mass 2
	$concave
}
