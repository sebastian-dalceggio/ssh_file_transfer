resource "tls_private_key" "ssh_file_transfer_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_file_transfer_private_key" {
  content         = tls_private_key.ssh_file_transfer_key.private_key_pem
  filename        = pathexpand("~/.ssh/ssh_file_transfer_private_key")
  file_permission = "0600"
}

resource "aws_key_pair" "ssh_file_transfer_key_pair" {
  key_name   = "ssh_file_transfer_key_pair"
  public_key = tls_private_key.ssh_file_transfer_key.public_key_openssh
  tags = {
    name    = "ssh_file_transfer_key_pair"
    project = var.project_name
  }
}
