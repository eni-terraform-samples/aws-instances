output "load_balancer_dns_name" {
  description = "The DNS name of the created load-balancer"
  value       = aws_lb.alb.dns_name
}
