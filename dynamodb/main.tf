module "dynamodb" {
    source                          = "../modules/dynamodb"
    destBucketName                  = module.destStorage.destBucketArn
    destRegion                      = var.dest_region
    backupFileName                  = "live-project-dynamodb-backup.csv"
    destBucketArn                   = module.destStorage.destBucketArn
    destKmsArn                      = module.destStorage.destKmsArn
    
    providers = {
        aws = aws.source
    }
}

module "destStorage" {
    source                          = "../modules/destStorage"
    
    providers = {
      aws = aws.dest
    }
}