$modelname "au_skeld/security_cam_alt.mdl"
$body security_cam_alt "security_cam_alt.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$texturegroup skinfamilies
{
	{ security_cam security_cam_lens security_cam_light_off  } //Skin 0
	{ security_cam security_cam_lens security_cam_light } //Skin 1
}

$sequence idle "security_cam_alt"

$collisionmodel "security_cam_alt_phys.smd"
{
	$mass 1
	$concave
}
