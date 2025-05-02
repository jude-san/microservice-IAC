module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = "10.0.0.0/16"
  public_cidr_block  = "10.0.1.0/24"
  private_cidr_block = "10.0.2.0/24"
  availability_zone  = "eu-north-1a"
}

module "security_group" {
  source      = "./modules/security_group"
  name        = "web-sg"
  description = "Allow SSH"
  vpc_id      = module.vpc.vpc_id
}

module "project" {
  source           = "./modules/ec2"
  ami              = data.aws_ami.ubuntu.id
  instance_type    = "t3.medium"
  instance_count   = 2
  subnet_id        = module.vpc.public_subnet_id
  sg_id            = module.security_group.sg_id
  key_name         = "dev-keypair"
  role             = "project"
  enable_public_ip = true
}


### sends public ip to ansible inventory directory if it exists
resource "local_file" "ansible_inventory" {
  content = join("\n", module.project.public_ip)
  # filename = "${path.module}/ansible-conf/inventories/hosts"
  filename = "../ansible-conf/inventories/hosts"
}
