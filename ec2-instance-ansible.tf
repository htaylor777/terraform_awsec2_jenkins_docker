// create ec2 instance and key-pair

resource "aws_key_pair" "ssh-key" {
    key_name = "Jenkins-Key"
    public_key =  file(var.public_key_location)
}


// @ami image:
// Query AWS to pull the latest AMI ID:  I went to AWS console to lookup 
// the ami-image under launch EC2 instance free tier to lookup "owner(s)"
// use regular expressions to filter(s) to narrow-down the query search
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

// test the output of our query:
output "ec2_public_ip" {
    value = aws_instance.myapp-jenkins-server.public_ip
}

// test the output of our query:
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}


resource "aws_instance" "myapp-jenkins-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    
 // Add this EC2 to our subnet_id,security group_id and avaialability_zone
    subnet_id = aws_subnet.myapp-default-subnet1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.subnet_avail_zone1b

// to access from web browser:
    associate_public_ip_address = true

// ***NOTE-manually create a key-pair on Amazon - once it's downloaded, physically move ot
// from Downloads to my local .ssh   
    key_name = aws_key_pair.ssh-key.key_name

// Name of this ec2 server:
    tags = {
        Name: "server-jenkins" 
    }
}


//INSTALL JENKINS: an empty resource block
resource "null_resource" "installjenkins" {
provisioner "local-exec" {
command = "ansible-playbook ansible_terraform/jenkins_install_playbook.yaml -i ansible_terraform/my_aws_ec2.yml --limit aws_ec2"
}
// @uncomment below if you want to run the jenkins install on each build:
triggers = {
build_number = "${timestamp()}"
 }

depends_on = [aws_instance.myapp-jenkins-server]
}


// points to the initial admin password
resource "null_resource" "admin_check" {
connection {
    type  = "ssh"
    user  = "ec2-user"
    private_key = file(var.private_key_location)
    host = aws_instance.myapp-jenkins-server.public_ip
}
// install Jenkins (copies jenkins_admin_check.sh script to the ec2 remote machine)
provisioner "remote-exec" {
    inline = [
        "echo 'initial admin password:'",
        "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]  
  }
triggers = {
build_number = "${timestamp()}"
}
depends_on = [null_resource.installjenkins]
}



# INSTALL DOCKER: uses an empty resource block
resource "null_resource" "docker" {
provisioner "local-exec" {
command = "ansible-playbook ansible_terraform/docker_install_playbook.yaml -i ansible_terraform/my_aws_ec2.yml --limit aws_ec2"
}
// @uncomment below if you want to run the docker install on each build:
triggers = {
build_number = "${timestamp()}"
 }
depends_on = [null_resource.installjenkins]
}


output "website_url" {
    value = join ("",["http://", aws_instance.myapp-jenkins-server.public_dns, ":", "8080"])
}


