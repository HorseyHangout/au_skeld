$modelname "au_skeld/shield_panel"
$body shield_panel "shield_panel.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "shield_panel"

$collisionmodel "shield_panel_phys.smd"
{
	$mass 20
	$concave
}
