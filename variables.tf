#vpc
variable "vpc_cidr_block" {
  type    = string
  default = "10.123.0.0/16"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "mtc_vpc_tags" {
  type = map(string)
  default = {
    Name = "dev"
  }
}

#subnet
variable "subnet_cidr_block" {
  type    = string
  default = "10.123.1.0/24"
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "subnet_vpc_tags" {
  type = map(string)
  default = {
    Name = "dev-public"
  }
}

#internet_gateway
variable "igw_tags" {
  type = map(string)
  default = {
    Name = "dev-igw"
  }
}

#route_table
variable "public_rt_tags" {
  type = map(string)
  default = {
    Name = "dev_public_rt"
  }
}

#default_route
variable "destination_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

#security group
variable "sg_name" {
  type    = string
  default = "dev_sg"
}

variable "sg_description" {
  type    = string
  default = "dev security group"
}

variable "sg_ingress" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = set(string)
  })
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #replace this cidr block with your terminal IP address
  }
}

variable "sg_egress" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = set(string)
  })
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#key pair
variable "key_name" {
  type    = string
  default = "mtckey"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/mtckey.pub"
}

#ec2 instance
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "user_data_filename" {
  type    = string
  default = "userdata.tpl"
}

variable "volume_size" {
  type    = number
  default = 10
}

variable "instance_tags" {
  type = map(string)
  default = {
    Name = "dev-node"
  }
}

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "identityfile_path" {
  type    = string
  default = "~/.ssh/mtckey"
}

variable "host_os" {
  type    = string
  default = "linux-ssh-config.tpl"
}
