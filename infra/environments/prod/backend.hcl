bucket         = "sebcel-bottled-vftw-terraform-state"
key            = "prod/terraform.tfstate"
region         = "eu-central-1"

dynamodb_table = "sebcel-bottled-vftw-terraform-locks"

encrypt = true