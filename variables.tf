
variable "your_AWS_region"{
    type = string

}
variable "your_AWS_account_access_key" {
  type=string
}

variable "your_AWS_account_secret_key" {
    type=string
}

variable "image" {
    description = "image of the EC2 instance"
    type        = string
    default     = "ami-01aab85a5e4a5a0fe" #Amazon Linux 2 AMI (HVM)
}

variable "inst_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "inst_tag" {
  description = "EC2 instance tag"
  type        =map(string)
  default     = {
    Name="instance-1"
    }
}

variable "vpc_tag" {
  description = "VPC network tag"
  type = map(string)
  default = {
    Name = "vpc-a"
    }
}

variable "ports" {
  type = map(number)
}

variable "my_cidr_blocks" {
  type = map(any)
}

variable "your_key" {
    type = string
}


