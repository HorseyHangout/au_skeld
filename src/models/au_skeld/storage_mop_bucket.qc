$modelname "au_skeld/storage_mop_bucket.mdl"
$body storage_mop_bucket "storage_mop_bucket.smd"
$surfaceprop metal
$cdmaterials "au_skeld/models"
$staticprop
$scale 1
$opaque

$sequence idle "storage_mop_bucket"

$collisionmodel "storage_mop_bucket_phys.smd"
{
	$mass 20
	$concave
}
