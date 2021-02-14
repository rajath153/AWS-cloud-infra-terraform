inst_tag={
    Name="web-server"
}
region = "xxx" # your prefered AWS region
ac_key="xxx"#Supply your AWS Access Key under xxx
sec_key="xxx"#Supply your AWS secret Key under xxx 
image="ami-0996d3051b72b5b2c" #Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
ports = {
    ssh = 22
    http = 80
    https = 443 
    icmp = -1
    allow_all = 0
}
my_cidr_blocks = {
    vpc-a_cidr_block = ["10.0.10.0/24"]
    allow_all_cidr_block = ["0.0.0.0/0"]
    subnet_cidr_block = ["10.0.10.0/25","10.0.10.128/25"]
}
your_key = "xxx" # Supply your key name to access the AWS instance

