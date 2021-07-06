module "code_commit" {
    source          = "../modules/cicd/"
    repo_name       = "webserver"
}