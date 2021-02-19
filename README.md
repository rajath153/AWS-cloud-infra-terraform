# AWS-cloud-infra-terraform

In this project, we will have a simple Ubuntu 20.04 LTS Apache2 webserver setup in the AWS cloud using terraform. At the end of the project, you will display the message "my web server" by accessing the Public IP address of the instance through your web browser.

Prerequisite: Install Terraform on your local machine before cloning this repository.

Following are the steps performed:

1. Creation of a VPC Network.
2. Creation of the Internet Gateway and its routing table.
3. Addition of two public subnets within the VPC.
4. Associate the routing table created in step 2 to the subnet.
5. Adding security groups to the VPC.
6. Creation of network interface for the IP in the public subnet.
7. Allocate AWS elastic IP to the created network interface.
8. Create a webserver using the AWS EC2 instance.

File description:

1. provider.tf  - contains AWS provider terraform configuration.
2. main.tf      - contains resource definition of the project.
3. variables.tf - contains declaration of variables used by the resources.
4. aws.tfvars   - contains definition of variables used by the resources.


Terraform commands to be executed:

1. terraform init                       # to initialize a working directory containing Terraform configuration files.
2. terraform plan -var-file aws.tfvars  # to create an execution plan
3. terraform apply -var-file aws.tfvars # to apply the changes required to reach the desired state of the configuration.

You need to supply your own AWS account's "Access key", "Secret key", "AWS region" and public-key name created in your account to access the EC2 instance in the prompt while running the commands "terraform plan -var-file aws.tfvars" and "terraform apply -var-file aws.tfvars".





