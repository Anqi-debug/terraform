resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = var.mtc_vpc_tags
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zone

  tags = var.subnet_vpc_tags
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = var.igw_tags
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags   = var.public_rt_tags
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = var.sg_ingress.from_port
    to_port     = var.sg_ingress.to_port
    protocol    = var.sg_ingress.protocol
    cidr_blocks = var.sg_ingress.cidr_blocks
  }

  egress {
    from_port   = var.sg_egress.from_port
    to_port     = var.sg_egress.to_port
    protocol    = var.sg_egress.protocol
    cidr_blocks = var.sg_egress.cidr_blocks
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "dev_node" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file(var.user_data_filename)

  root_block_device {
    volume_size = var.volume_size
  }

  tags = var.instance_tags

  provisioner "local-exec" {
    command = templatefile(var.host_os, {
      hostname     = self.public_ip,
      user         = var.user_name,
      identityfile = var.identityfile_path
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}