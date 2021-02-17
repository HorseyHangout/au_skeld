$modelname "au_skeld/o2_panel.mdl"
$body o2_panel "o2_panel.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "o2_panel"

$collisionmodel "o2_panel_phys.smd"
{
	$mass 5
	$concave
}
