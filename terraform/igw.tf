resource "aws_internet_gateway" "igw_handsync" {
  vpc_id = aws_vpc.vpc_handsync.id
  tags = { Name = "igw-handsync" }
}