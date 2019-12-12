provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_security_group" "service-discovery-security-group" {
 name = "lesson1hw"
 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
   from_port       = 0
   to_port         = 0
   protocol        = "-1"
   cidr_blocks     = ["0.0.0.0/0"]
 }
}

#Create EC2 Web Instances
resource "aws_instance" "consul-server" {
    ami = "${var.ami}"
    count = "${var.instance_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    user_data = "${file("install_consul.sh")}"
    vpc_security_group_ids = ["${aws_security_group.service-discovery-security-group.id}"]
    tags = {
        Name = "consul-server${count.index}"
    }
  
}

resource "aws_instance" "web-server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    user_data = "${file("install_apache.sh")}"
    vpc_security_group_ids = ["${aws_security_group.service-discovery-security-group.id}"]
    tags = {
        Name = "web-server"
    }    
}