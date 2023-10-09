module "s3_website" {
  count       = 2 #terraform.workspace == "dev" ? 2 : 5
  source      = "../2_s3_com_website"
  bucket_name = "criado-modulos${count.index + 1}-diego-${terraform.workspace}"
}

# module "diego_vpc" {
#   source = "../4_vpc"
#   vpc_cird = "172.16.1.0/25"
#   subnet_cidr_block = ["172.16.1.48/28", "172.16.1.64/28"]
#   subnet_availability_zone = ["us-east-1a", "us-east-1b"]
#   subnet_count = 2
# }

output "bucket_endpoint" {
  value = module.s3_website[*].bucket_url
}
