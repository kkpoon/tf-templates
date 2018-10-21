variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "terraform-simple"
  public_key = "${trimspace(file("~/.ssh/id_rsa.pub"))}"
}

resource "digitalocean_droplet" "hello1" {
  image     = "ubuntu-18-04-x64"
  name      = "hello1"
  region    = "sgp1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = ["${digitalocean_ssh_key.default.fingerprint}"]
  user_data = "${data.template_file.init.rendered}"

  tags = ["Development"]
}

data "template_file" "init" {
  template = "${file("${path.module}/../init.tpl")}"
}

output "hello1-ip" {
  value = "${digitalocean_droplet.hello1.ipv4_address}"
}
