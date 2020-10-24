$modelname "au_skeld/data_pad.mdl"
$body data_pad "data_pad.smd"
$surfaceprop glass
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "data_pad"

$collisionmodel "data_pad_phys.smd"
{
	$mass 1.3
	$concave
}
