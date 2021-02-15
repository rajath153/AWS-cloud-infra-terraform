#configure provider

provider "aws" {
  region = var.your_AWS_region
  access_key=var.your_AWS_account_access_key
  secret_key=var.your_AWS_account_secret_key
}
