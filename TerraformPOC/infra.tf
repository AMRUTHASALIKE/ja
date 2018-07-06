module "vpc"
{
 source = "./modules/vpc"
}

provider "aws"
{
 region = "eu-west-3"

}

output "ip"{
value = "${module.vpc.ip}"
}
