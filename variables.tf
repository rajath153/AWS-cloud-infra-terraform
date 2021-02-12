
variable "region"{
    type = string
    
}
variable "ac_key" {
  type=string
}

variable "sec_key" {
    type=string
}

variable "image" {
    type=string
    default = "ami-01aab85a5e4a5a0fe" #Amazon Linux 2 AMI (HVM)
}

variable "inst_type" {
    type = string
    default = "t2.micro"
}

variable "inst_tag" {
  type=map(string)
  default={
    Name="instance-1"
    }
}

variable "vpc_tag" {
  type = map(string)
  default = {
    Name = "vpc-a"
    }
}

variable "cidr_range" {
  type = string
}

variable "subnet_cidr" {
  type = list(string)
}

