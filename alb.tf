data "aws_availability_zones" "zones" {
  state = "available"
}

# Load balancer definition
resource "aws_lb" "alb" {
  name               = "sw-alb"
  load_balancer_type = "application"

  dynamic "subnet_mapping" {
    for_each = toset(data.aws_availability_zones.zones.names)

    content {
      subnet_id = aws_subnet.public_subnet[subnet_mapping.value].id
    }
  }
}

# HTTP listener of the load-balancer, that forwards requests to the target instances
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target.arn
  }
}

# target group referencing the instances
resource "aws_lb_target_group" "web_target" {
  name     = "sw-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# each zone has its instance attached
resource "aws_lb_target_group_attachment" "this" {
  for_each = toset(data.aws_availability_zones.zones.names)

  target_group_arn = aws_lb_target_group.web_target.arn
  target_id        = aws_instance.web[each.value].id
  port             = 80
}
