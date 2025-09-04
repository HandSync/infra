# Subnet pública 1a
resource "aws_subnet" "subrede_publica_1a" {
  vpc_id                  = aws_vpc.vpc_handsync.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = { Name = "handsync-publica-1a" }
}

# Subnet pública 1b
resource "aws_subnet" "subrede_publica_1b" {
  vpc_id                  = aws_vpc.vpc_handsync.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = { Name = "handsync-publica-1b" }
}

data "aws_availability_zones" "available" {}


# Subnet privada 1a
resource "aws_subnet" "subrede_privada_1a" {
  vpc_id            = aws_vpc.vpc_handsync.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "handsync-privada-1a" }
}

# Subnet privada 1b
resource "aws_subnet" "subrede_privada_1b" {
  vpc_id            = aws_vpc.vpc_handsync.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "handsync-privada-1b" }
}
