// VARIABLES
variable "aws_vpc_cidr_block_default" {}
variable "aws_subnet_cidr_default_1" {}
variable "aws_subnet_cidr_default_2" {}
variable "aws_subnet_cidr_default_3" {}

variable "vpc_cidr_block_dev" {}
variable "subnet_cidr_block_default" {}
variable "subnet_avail_zone1b" {}

variable "env_prefix" {}
variable "env_prefix_default" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}
variable "my_ip" {}
variable "instance_type" {}
variable "ec2_instance_jenkins" {}
variable "public_key_location" {}
variable "private_key_location" {}
variable "user" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

//----------VPC RESOURCES 

// create vpc block "10.0.0.0/16" for EC2
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block_dev
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

// AWS creates by default ====================
// create default vpc block "172.31.0.0/16" 
resource "aws_vpc" "myapp-vpc-default" {
  cidr_block = var.aws_vpc_cidr_block_default
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name : "${var.env_prefix_default}-vpc"
  }
}

// ----------VPC SUBNETS: 
//@aws_subnet
//create private subnet 10.0.10.0/24 connected to vpc "myapp-vpc"
resource "aws_subnet" "myapp-cidr-block-default-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block_default
  availability_zone = var.subnet_avail_zone1b
  tags = {
    Name : "${var.env_prefix}-cidr-block-subnet"
  }
}


// AWS creadted by default ====================
// 3 subnets: 172.31.0...etc.
resource "aws_subnet" "myapp-default-subnet1" {
  vpc_id            = aws_vpc.myapp-vpc-default.id
  cidr_block        = var.aws_subnet_cidr_default_1
  availability_zone = var.subnet_avail_zone1b
  tags = {
    Name : "${var.env_prefix_default}-default-subnet1"
  }
}

resource "aws_subnet" "myapp-default-subnet2" {
  vpc_id            = aws_vpc.myapp-vpc-default.id
  cidr_block        = var.aws_subnet_cidr_default_2
  availability_zone = var.subnet_avail_zone1b
  tags = {
    Name : "${var.env_prefix_default}-default-subnet2"

  }
}

resource "aws_subnet" "myapp-default-subnet3" {
  vpc_id            = aws_vpc.myapp-vpc-default.id
  cidr_block        = var.aws_subnet_cidr_default_3
  availability_zone = var.subnet_avail_zone1b
  tags = {
    Name : "${var.env_prefix_default}-default-subnet3"
  }
}

