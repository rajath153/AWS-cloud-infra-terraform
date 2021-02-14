#configure provider

provider "aws" {
  region = var.region
  access_key=var.ac_key
  secret_key=var.sec_key
}
