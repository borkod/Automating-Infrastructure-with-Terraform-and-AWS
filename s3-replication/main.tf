module "storage" {
    source                          = "../modules/storage"
    destBucketArn                   = module.destStorage.destBucketArn
    destKmsArn                      = module.destStorage.destKmsArn
}

module "destStorage" {
    source                          = "../modules/destStorage"
    providers = {
      aws = aws.usw
    }
}