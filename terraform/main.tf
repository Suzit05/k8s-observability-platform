terraform {
required_version = ">= 1.5.0"

required_providers {   #Prevents version breaking changes
                       #Real companies always lock provider versions
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}

provider "aws" {
region = var.region
}
resource "aws_key_pair" "mykeypair" {
  key_name = "mykey"
  public_key = file("/mnt/c/Users/sujee/.ssh/id_rsa.pub")
}

resource "aws_security_group" "k8s_sg" {
  name = "k8s-cluster-sg"
  ingress { #ssh
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }
  ingress { #k8s api server----------crucial for interaction of master and worker nodes
    from_port = 6443
    to_port = 6443
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }
  ingress { #nodeport services
    from_port = 30000
    to_port = 32767
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }
# Allow all internal traffic between cluster nodes
  # Taaki Master aur Workers aapas mein bina rukawat baat kar sakein
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress { 
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "-1"
  }


}

#for k8s -cluster 
resource "aws_instance" "control_plane" { #control plane node- the brain
  ami = var.ami
  instance_type = "t3.medium"
  key_name = aws_key_pair.mykeypair.key_name

  vpc_security_group_ids = [ aws_security_group.k8s_sg.id ]
  user_data = file("${path.module}/bootstrap.sh")

  tags = {
    Name = "k8s-control-plane"
    Environment = "dev"
    Project = "k8s-observability-platform"
  }
}


resource "aws_instance" "worker_node" {   #worker node - the muscles - where the pod actually run
  count = 2
  ami = var.ami
  instance_type = var.instance_type  #t2.micro
  key_name = aws_key_pair.mykeypair.key_name

  vpc_security_group_ids = [ aws_security_group.k8s_sg.id ]
  user_data = file("${path.module}/bootstrap.sh")

  tags = {
    Name= "k8s-worker-${count.index}"
    Environment = "dev"
    Project = "k8s-observability-platform"    
  }
}

#ssh -i ~/.ssh/id_rsa ubuntu@51.20.98.96

#control_node_ip = "13.53.149.194"
#worker_node_ip = [
 # "13.63.155.239",
  #"51.20.98.96",
