data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc"]
  }
}

data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id # Ensure it's in the correct VPC
  filter {
    name   = "tag:Name"
    values = ["my-subnet-1"] # Or the name/tag of your target subnet
  }
}
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Broad access for SSH, restrict in production!
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
    description = "Allow HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServerSG"
  }
}

resource "aws_instance" "web-server-1" {
    ami    = "ami-05fcfb9614772f051" # Example AMI ID, replace with a valid one for your region
    subnet_id         = data.aws_subnet.existing_subnet.id
    security_groups   = [aws_security_group.web_server_sg.id] # Attach the security group
    key_name          = "ec2-kp" # Replace with your actual key pair name
    associate_public_ip_address = true # Ensure the instance gets a public IP    
    availability_zone = "eu-north-1a"
    instance_type     = "t3.micro"
    tags = {
        Name = "web-server-1"
    } 
}

output "web_server_public_ip" {
  value       = aws_instance.web-server-1.public_ip
  description = "Public IP address of the web server"
}

output "web_server_private_ip" {
  value       = aws_instance.web-server-1.private_ip
  description = "Private IP address of the web server"
}
