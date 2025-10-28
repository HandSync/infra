# Load Balancer (ALB)
resource "aws_lb" "alb_front" {
  name               = "handsync-alb-front-v2"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subrede_publica_1a.id, aws_subnet.subrede_publica_1b.id]
  security_groups    = [aws_security_group.sg_publica.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_front.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_tg.arn
  }
}

resource "aws_lb_target_group" "front_tg" {
  name     = "handsync-front-tg-v2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_handsync.id

  health_check {
    path = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "front_1a" {
  target_group_arn = aws_lb_target_group.front_tg.arn
  target_id        = aws_instance.ec2_front_1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "front_1b" {
  target_group_arn = aws_lb_target_group.front_tg.arn
  target_id        = aws_instance.ec2_front_1b.id
  port             = 80
}
