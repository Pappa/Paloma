terraform {

    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }

    backend "s3" {
        bucket = "dung-beetle-bash-terraform-backend"
        key    = "paloma"
        region = "eu-west-1"
    }
    
}

provider "aws" {
 region = "eu-west-1"
 default_tags {
   tags = {
     Project     = "Paloma"
   }
 }
}