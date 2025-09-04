# EC2 Front-end
resource "aws_instance" "ec2_front_1a" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.subrede_publica_1a.id
  vpc_security_group_ids = [aws_security_group.sg_publica.id]
  associate_public_ip_address = true

  tags = { Name = "handsync-front-1a" }
}

resource "aws_instance" "ec2_front_1b" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.subrede_publica_1b.id
  vpc_security_group_ids = [aws_security_group.sg_publica.id]
  associate_public_ip_address = true

  tags = { Name = "handsync-front-1b" }
}

# EC2 Back-end
resource "aws_instance" "ec2_back_1a" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.subrede_privada_1a.id
  vpc_security_group_ids = [aws_security_group.sg_privada.id]
  associate_public_ip_address = false

  tags = { Name = "handsync-back-1a" }
}

resource "aws_instance" "ec2_back_1b" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.subrede_privada_1b.id
  vpc_security_group_ids = [aws_security_group.sg_privada.id]
  associate_public_ip_address = false

  tags = { Name = "handsync-back-1b" }
}
