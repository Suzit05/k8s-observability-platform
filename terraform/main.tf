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
  egress { 
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "0"
  }


}

resource "aws_instance" "control_plane" { #control plane node- the brain
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.mykeypair.key_name

  vpc_security_group_ids = [ aws_security_group.k8s_sg.id ]

  tags = {
    Name = "k8s-control-plane"
    Environment = "dev"
    Project = "k8s-observability-platform"
  }
}


resource "aws_instance" "worker_node" {   #worker node - the muscles - where the pod actually run
  count = 2
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.mykeypair.key_name

  vpc_security_group_ids = [ aws_security_group.k8s_sg.id ]

  tags = {
    Name= "k8s-worker-${count.index}"
  }
}

#ssh -i ~/.ssh/id_rsa ubuntu@13.62.50.187