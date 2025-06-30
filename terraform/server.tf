resource "aws_instance" "ssh_file_transfer_ec2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro" # Free tier
  key_name                    = aws_key_pair.ssh_file_transfer_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.ssh_file_transfer_sg.id]
  subnet_id                   = aws_subnet.ssh_file_transfer_subnet.id
  associate_public_ip_address = true

  # User data script to create the test.txt file on instance launch
  user_data = <<-EOF
              #!/bin/bash
              echo "This is a test file created by user data." > /home/ec2-user/test.txt
              chmod 644 /home/ec2-user/test.txt
              EOF

  tags = {
    name    = "ssh_file_transfer_ec2"
    project = var.project_name
  }
}