inst_tag={
    Name="web-server"
}
region = "us-east-2"
ac_key="xxx"#Supply your AWS Access Key under xxx
sec_key="xxx"#Supply your AWS secret Key under xxx 
image="ami-0996d3051b72b5b2c" #Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
cidr_range = "10.0.10.0/24"
subnet_cidr = ["10.0.10.0/25","10.0.10.128/25"]