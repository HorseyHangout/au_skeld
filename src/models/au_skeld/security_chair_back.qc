$modelname "au_skeld/security_chair_back"
$body security_chair_back "security_chair_back.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "security_chair_back"

$collisionmodel "security_chair_back_phys.smd"
{
	$mass 5
	$concave
}
