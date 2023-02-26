terraform {

    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }

    backend "s3" {
        bucket = "paloma-terraform-backend"
        key    = ""
        region = "eu-west-1"
    }
    
}

provider "aws" {
 region = "eu-west-1"
}