$modelname "au_skeld/shield_console.mdl"
$body shield_console "shield_console.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "shield_console"

$collisionmodel "shield_console_phys.smd"
{
	$mass 300
	$concave
}
