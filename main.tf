
#Create a VPC Network
resource "aws_vpc" "my_vpc" {
  cidr_block       = element(var.my_cidr_blocks["vpc-a_cidr_block"],0)
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
    cidr_block = element(var.my_cidr_blocks["allow_all_cidr_block"],0)
    gateway_id = aws_internet_gateway.in_gw.id
  }

  tags = {
    Name = "internet-route"
  }
}

#Adding subnets to my_vpc
resource "aws_subnet" "my_subnets" {
  count = length(var.my_cidr_blocks["subnet_cidr_block"])
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = element(var.my_cidr_blocks["subnet_cidr_block"],count.index)
  tags = {
    Name="subnet-${count.index+1}"
  }
}

#Route Table Association with the subnet
resource "aws_route_table_association" "associate" {
  count = length(var.my_cidr_blocks["subnet_cidr_block"])
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
    from_port   = var.ports["ssh"]
    to_port     = var.ports["ssh"]
    protocol    = "tcp"
    cidr_blocks = var.my_cidr_blocks["allow_all_cidr_block"]
  }

  ingress {
    description = "Allow icmp"
    from_port   = var.ports["icmp"]
    to_port     = var.ports["icmp"]
    protocol    = "icmp"
  }

  ingress {
    description = "Allow HTTP"
    from_port   = var.ports["http"]
    to_port     = var.ports["http"]
    protocol    = "tcp"
    cidr_blocks = var.my_cidr_blocks["allow_all_cidr_block"]
  }


  ingress {
    description = "Allow HTTPS"
    from_port   = var.ports["https"]
    to_port     = var.ports["https"]
    protocol    = "tcp"
    cidr_blocks = var.my_cidr_blocks["allow_all_cidr_block"]
  }

   egress {
    description = "Allow all ports towards external traffic "
    from_port   = var.ports["allow_all"]
    to_port     = var.ports["allow_all"]
    protocol    = "-1" # Any Protocol
    cidr_blocks = var.my_cidr_blocks["allow_all_cidr_block"]
  }

  tags = {
    Name="allow-web"
  }

}

#create Network interface and add IP in the subnet-1 range
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
  key_name = var.your_Public_key # your AWS key name to access instance
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

