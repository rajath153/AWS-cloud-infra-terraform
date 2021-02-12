
#Create a VPC Network
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.cidr_range
  instance_tenancy = "default"
  tags = var.vpc_tag
}

#Create Internet Gateway 
resource "aws_internet_gateway" "in_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-gateway"
  }
}

#Create Routing Table for the Internet Gateway
resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.in_gw.id
  }

  tags = {
    Name = "internet-route"
  }
}

#Adding subnets to my_vpc
resource "aws_subnet" "my_subnets" {
  count = length(var.subnet_cidr)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = element(var.subnet_cidr,count.index)
  tags = {
    Name="subnet- ${count.index+1}"
  }
}

#Route Table Association with the subnet
resource "aws_route_table_association" "associate" {
  count = length(var.subnet_cidr)
  subnet_id = element(aws_subnet.my_subnets.*.id,count.index)
  route_table_id = aws_route_table.internet-route.id
}

#Adding security groups to the VPC
resource "aws_security_group" "my-sg" {
  name        = "security-group-1"
  description = "security group to allow SSH, Ping, HTTP and HTTPS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    description = "All external ports are accessible"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name="allow-web"
  }

}

#create IP in the subnet-1
resource "aws_network_interface" "my_interface" {
  subnet_id       = aws_subnet.my_subnets[0].id
  private_ips     = ["10.0.10.10"]
  security_groups = [aws_security_group.my-sg.id]  
}

#Allocate elastic IP to our created interface
resource "aws_eip" "elastic_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.my_interface.id
  associate_with_private_ip = "10.0.10.10"
  depends_on = [aws_internet_gateway.in_gw]
}

#Create an EC2 instance
resource "aws_instance" "test_instance" {
  ami           = var.image
  instance_type = var.inst_type
  key_name = "dns"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.my_interface.id

  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo my web server > /var/www/html/index.html'
              EOF

  tags = var.inst_tag
}








