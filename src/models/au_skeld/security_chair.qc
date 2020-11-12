$modelname "au_skeld/security_chair"
$body security_chair "security_chair.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "security_chair"

$collisionmodel "security_chair_phys.smd"
{
	$mass 5
	$concave
}
