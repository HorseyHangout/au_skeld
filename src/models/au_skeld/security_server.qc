$modelname "au_skeld/security_server.mdl"
$body security_server "security_server.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1

$sequence idle "security_server"

$collisionmodel "security_server_phys.smd"
{
	$mass 200
	$concave
}
