Example:

module "s3_bucket" {
  source = "../EthanBegalkaTerraformModuleLibrary/s3_bucket"

  bucket_name = "bucketname"
  acl = "private"
  object_ownership = "BucketOwnerPreferred"
}