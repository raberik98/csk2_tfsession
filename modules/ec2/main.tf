resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [ aws_security_group.ec2_sg.id ]
  subnet_id = var.subnet_id

  associate_public_ip_address = true

  key_name = var.key_name != "" ? var.key_name : null

  tags = merge({
    Name = var.name
    Type = "EC2 instance"
  }, var.tags)
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_standard_sg"
  vpc_id      = var.vpc_id 

  ingress {
    description = "Allow HTTP traffic on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow HTTP traffic on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow SSH traffic on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}






# resource "aws_instance" "bastion" {
#   ami           = var.ami
#   instance_type = var.ami

#   tags = merge({
#     Name = var.name,
#     Type = "Bastion host"
#   }, var.tags)

#   depends_on = [ aws_key_pair.bastion ]
# }

