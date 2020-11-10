$modelname "au_skeld/security_cam.mdl"
$body security_cam "security_cam.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$texturegroup skinfamilies
{
	{ security_cam security_cam_lens security_cam_light_off  } //Skin 0
	{ security_cam security_cam_lens security_cam_light } //Skin 1
}

$sequence idle "security_cam"

$collisionmodel "security_cam_phys.smd"
{
	$mass 1
	$concave
}
