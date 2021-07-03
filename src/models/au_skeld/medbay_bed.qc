$modelname "au_skeld/medbay_bed.mdl"
$body medbay_bed "medbay_bed.smd"
$surfaceprop carpet
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "medbay_bed"

$collisionmodel "medbay_bed_phys.smd"
{
	$mass 100
	$concave
}
