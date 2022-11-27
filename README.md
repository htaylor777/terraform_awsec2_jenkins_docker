This infrastructure code is orchestrated by terraform. 
PURPOSE: This will installs on AWS 
- VPC's, 
- All required Subnets 
- Public IPv4 DNS 
- EC2 Instance (t2.micro)
- Installs Jenkins
- Installs Docker
- Installs git
- Security groups:
-  with Inbound rules:
-     SSH (port 22) 
-     HTTPS (port 443)
-     HTTP (Port 80)
-     HTTP (Port 8080) 
-  with Outbound rules:
-     ALL Ports and Addresses accesses 
-  dev-sgroup
- routing tables - automatic from AWS
  
## Versions used 
- Terraform - 1.1.6
- AWS provider - 4.2.0
- VPC module - 3.12.0


## Commands used in the Course

### initialize

    terraform init

### preview terraform actions

    terraform plan

### apply configuration with variables

    terraform apply -var-file terraform-dev.tfvars

### destroy a single resource

    terraform destroy -target aws_vpc.myapp-vpc

### destroy everything fromtf files

    terraform destroy

### show resources and components from current state

    terraform state list

### show current state of a specific resource/data

    terraform state show aws_vpc.myapp-vpc    

### set avail_zone as custom tf environment variable - before apply

    export TF_VAR_avail_zone="eu-west-3a"


## More Information: AWS Services and components we use or create with Terraform
- Amazon EC2 - Virtual Server: https://aws.amazon.com/ec2
- Amazon VPC - Your Virtual Private Network on AWS: https://aws.amazon.com/vpc
- Subnet - Subnetwork, logical subdivision of IP network: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
- Internet Gateway - a VPC component: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
- Security Group - Virtual Firewall: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
- Route Table - Configuring Network Traffic: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
- Amazon S3  - Simple Storage: https://aws.amazon.com/s3/
