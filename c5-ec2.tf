resource "aws_instance" "web" {
  ami           = "ami-0f1834be8d049e69f"
  instance_type = "t3.micro"

  tags = {
    Name = "First instance"
  }

  subnet_id = values(aws_subnet.public)[1].id
  vpc_security_group_ids = [ aws_security_group.sg ]
  associate_public_ip_address = true
  key_name = "ec2_machine"

}