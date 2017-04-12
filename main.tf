#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:
#
#     subnet-7e08481a
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-pony
#

#module "example" {
#  source = "./example-module"
#  command = "echo 'Russell is Awesome!'"
#}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_count" {
  type    = "string"
  default = "3"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami           = "ami-eea9f38e"
  instance_type = "t2.micro"
  count         = "${var.aws_count}"

  subnet_id              = "subnet-7e08481a"
  vpc_security_group_ids = ["sg-834d35e41"]

  tags {
    "Identity" = "autodesk-pony"
    "Name"     = "rainbow ${count.index + 1} of ${var.aws_count}"
    "Type"     = "unicorn"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "names" {
  value = ["${aws_instance.web.*.tags.Name}"]
}

terraform {
  backend "atlas" {
    name = "mobleyr/training"
  }
}
