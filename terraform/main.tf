resource "aws_instance" "web" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.medium"
  key_name = "my-private-key-pd"
  vpc_security_group_ids = [aws_security_group.monitoring-sg.id]
  user_data = templatefile("./install.sh",{})

  tags = {
    Name = "Monitoring"
  }
  root_block_device{
    volume_size = 20
    }
}
resource "aws_security_group" "monitoring-sg" {
  name        = "monitoring-sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22,443,8080,3000,9090,9100] :
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
    Name = "monitoring-sg"
  }
}