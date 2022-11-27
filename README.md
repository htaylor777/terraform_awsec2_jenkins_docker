This infrastructure code is orchestrated by terraform. 
PURPOSE: This will install the following on AWS: 
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
- routing tables
  
## Versions used 
- Terraform - 1.3.4
- AWS provider - latest
- VPC module - latest

_____________________________________________________________________________

Set up /etc/ansible/ansible.cfg

[defaults]
-enable_plugins = aws_ec2
-host_key_checking = False
-pipelining = True
-remote_user = ec2-user
-private_key_file=/<Your LocalPATH>/.ssh/id_rsa

-----------------------------------------------------------------------------
Set up /etc/ansible/hosts

[host]
-all 
-ansible_user=ec2-user 
-ansible_ssh_private_key_file=/<Your LocalPATH>/.ssh/id_rsa 
-ansible_connection=ssh

-----------------------------------------------------------------------------

## Commands used:
### initialize

    terraform init

### preview terraform actions

    terraform plan

### apply configuration with variables

    terraform apply -var-file terraform.tfvars

### destroy a single resource

    terraform destroy -target aws_vpc.myapp-vpc

### destroy everything fromtf files

    terraform destroy

### show resources and components from current state

    terraform state list

### show current state of a specific resource/data

    terraform state show aws_vpc.myapp-vpc    

### set avail_zone as custom tf environment variable - before apply

    export TF_VAR_avail_zone="us-west-1"


## More Information: AWS Services and components we use or create with Terraform
- Amazon EC2 - Virtual Server: https://aws.amazon.com/ec2
- Amazon VPC - Your Virtual Private Network on AWS: https://aws.amazon.com/vpc
- Subnet - Subnetwork, logical subdivision of IP network: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
- Internet Gateway - a VPC component: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
- Security Group - Virtual Firewall: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
- Route Table - Configuring Network Traffic: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
- Amazon S3  - Simple Storage: https://aws.amazon.com/s3/
