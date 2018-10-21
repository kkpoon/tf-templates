# Configure the AWS Provider
#
# export AWS_ACCESS_KEY_ID=""
# export AWS_SECRET_ACCESS_KEY=""
# export AWS_DEFAULT_REGION="ap-southeast-1"
provider "aws" {}

resource "aws_key_pair" "my-sshkey" {
  key_name_prefix   = "my-sshkey-"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "hello1" {
  ami           = "ami-0ac019f4fcb7cb7e6" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"

  tags {
    Type = "Development"
  }

  key_name = "${aws_key_pair.my-sshkey.key_name}"

  user_data = "${data.template_file.init.rendered}"
}

data "template_file" "init" {
  template = "${file("${path.module}/../init.tpl")}"
}


output "hello1-ip" {
  value = "${aws_instance.hello1.public_ip}"
}
