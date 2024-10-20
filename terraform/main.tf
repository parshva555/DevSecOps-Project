resource "aws_instance" "web" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.large"
  key_name = "my-private-key-pd"
  vpc_security_group_ids = [aws_security_group.netflix-jenkins-sg.id]
  user_data = templatefile("./install.sh",{})

  tags = {
    Name = "netflix-jenkins"
  }
  root_block_device{
    volume_size = 25
    }
}
resource "aws_security_group" "netflix-jenkins-sg" {
  name        = "netflix-jenkins-sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22,80,443,8080,9000,8081] :
        {
          description = "inbound rules"
          from_port = port
          to_port = port
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = []
          prefix_list_ids = []
          security_groups = []
          self = false 
        }
   ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "netflix-jenkins-sg"
  }
}