provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "example" {
  image               = "ubuntu-16-04-x64"
  name                = "example-droplet"
  region              = "tor1"
  size                = "s-1vcpu-1gb"
  private_networking  = "true"
  ssh_keys            = ["be:7e:93:d3:c9:b6:eb:54:99:e0:b5:60:b0:82:ce:fd"]
  user_data           = <<-EOF
                        #!/bin/bash
                        echo "Hello poussin" > index.html
                        nohup busybox httpd -f -p "${var.example_public_port}" &
                        EOF
}

resource "digitalocean_firewall" "example" {
  name = "only-22-and-${var.example_public_port}"

  droplet_ids = ["${digitalocean_droplet.example.id}"]

  inbound_rule = [
    {
      protocol          = "tcp"
      port_range        = "22"
      source_addresses  = ["${var.home_public_ip}"]
    },
    {
      protocol          = "tcp"
      port_range        = "${var.example_public_port}"
      source_addresses  = ["0.0.0.0/0"]
    }
  ]
}
