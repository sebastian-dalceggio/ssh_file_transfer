resource "aws_vpc" "ssh_file_transfer_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name    = "ssh_file_transfer_vpc"
    project = var.project_name
  }
}

resource "aws_subnet" "ssh_file_transfer_subnet" {
  vpc_id                  = aws_vpc.ssh_file_transfer_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    name    = "ssh_file_transfer_subnet"
    project = var.project_name
  }
}

resource "aws_internet_gateway" "ssh_file_transfer_igw" {
  vpc_id = aws_vpc.ssh_file_transfer_vpc.id
  tags = {
    name    = "ssh_file_transfer_igw"
    project = var.project_name
  }
}

resource "aws_route_table" "ssh_file_transfer_table" {
  vpc_id = aws_vpc.ssh_file_transfer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ssh_file_transfer_igw.id
  }

  tags = {
    name    = "ssh_file_transfer_table"
    project = var.project_name
  }
}

resource "aws_route_table_association" "ssh_file_transfer_rta" {
  subnet_id      = aws_subnet.ssh_file_transfer_subnet.id
  route_table_id = aws_route_table.ssh_file_transfer_table.id
}

resource "aws_security_group" "ssh_file_transfer_sg" {
  vpc_id      = aws_vpc.ssh_file_transfer_vpc.id
  name        = "ssh_file_transfer_sg"
  description = "Allow SSH inbound traffic"

  # Ingress rule for SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_current_ip.response_body)}/32"]
    description = "Allow SSH"
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    name    = "ssh_file_transfer_sg"
    project = var.project_name
  }
}