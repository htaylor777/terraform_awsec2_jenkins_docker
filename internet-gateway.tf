// handling: aws_internet_gateway, aws_route_table, aws_security_group

// @aws_internet_gateway:
// create internet gateway for internet access: vpc "myapp-vpc-default" -172.31.0.0/16 "
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc-default.id
    tags = {
        Name: "${var.env_prefix_default}-igw"
  }
}

// @aws_route_table:
// create and map routing table to vpc "myapp-vpc-default" -172.31.0.0/16 also for ssh access into the
// ec2 instances
resource "aws_route_table" "myapp-route-table" {
   vpc_id = aws_vpc.myapp-vpc-default.id
   route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.myapp-igw.id
   }
   tags = {
     Name: "${var.env_prefix_default}-rtbl"
  }
}
// `we need to associate subnet "172.31.0.0/24" with the routing table so the traffic within the 
// subnet can also be handled by the routing table. 
// refer line :myapp-cidr-block-default-subnet
resource "aws_route_table_association" "a-rtbl-subnet" {
   # subnet_id = aws_subnet.myapp-cidr-block-default-subnet.id
    subnet_id = aws_subnet.myapp-default-subnet1.id
    route_table_id = aws_route_table.myapp-route-table.id
}


// @aws_security_group:
// 172.31.0.0/16
// "added to open the firewall and open ports for ssh accesses: ingress"
// incoming internet traffic access port 8080 access :ingress"
// configure incoming rules for traffic coming into the vpc
resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc-default.id
   
   //ssh:
     ingress {
         from_port = 22
         to_port = 22
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

    //web browser:
      ingress {
         from_port = 80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

      //web browser:
      ingress {
         from_port = 8080
         to_port = 8080
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

       //web browser:
      ingress {
         from_port = 443
         to_port = 443
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }
    
    // exiting -outbound rules added -> all traffic 
    // allows any address to leave the vpc
      egress {
         from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Name: "${var.env_prefix}-sgroup"
      }
}
