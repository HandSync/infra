
# Route Table Pública
resource "aws_route_table" "route_table_publica" {
  vpc_id = aws_vpc.vpc_handsync.id

  route {
    cidr_block = var.cidr_geral
    gateway_id = aws_internet_gateway.igw_handsync.id
  }

  tags = { Name = "rt-handsync-publica" }
}

# Associação das subnets públicas
resource "aws_route_table_association" "subrede_publica_1a" {
  subnet_id      = aws_subnet.subrede_publica_1a.id
  route_table_id = aws_route_table.route_table_publica.id
}

resource "aws_route_table_association" "subrede_publica_1b" {
  subnet_id      = aws_subnet.subrede_publica_1b.id
  route_table_id = aws_route_table.route_table_publica.id
}
