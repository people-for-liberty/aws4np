## WordPress on AWS Lightsail
##
## Managed by spec 003 (setup/speckitSecondTrainingWordPress.md).
## Set enable_wordpress_lightsail = true in terraform.tfvars during §4 training.

resource "aws_lightsail_static_ip" "wordpress" {
  count = var.enable_wordpress_lightsail ? 1 : 0
  name  = "${var.org_slug}-wordpress-ip"
}

resource "aws_lightsail_instance" "wordpress" {
  count             = var.enable_wordpress_lightsail ? 1 : 0
  name              = "${var.org_slug}-wordpress"
  availability_zone = local.wordpress_availability_zone
  blueprint_id      = var.lightsail_wordpress_blueprint_id
  bundle_id         = var.lightsail_wordpress_bundle_id
}

resource "aws_lightsail_static_ip_attachment" "wordpress" {
  count          = var.enable_wordpress_lightsail ? 1 : 0
  static_ip_name = aws_lightsail_static_ip.wordpress[0].name
  instance_name  = aws_lightsail_instance.wordpress[0].name
}

resource "aws_lightsail_instance_public_ports" "wordpress" {
  count         = var.enable_wordpress_lightsail ? 1 : 0
  instance_name = aws_lightsail_instance.wordpress[0].name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidrs     = ["0.0.0.0/0"]
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs     = ["0.0.0.0/0"]
  }
}
