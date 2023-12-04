provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "webserver" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.web.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "web" {
  public_key = file(var.ssh)
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "publicip" {
  value = aws_instance.webserver.public_ip
}