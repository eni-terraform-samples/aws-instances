# getting the latest ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/*/ubuntu-noble-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# create an instance on each available zone
resource "aws_instance" "web" {
  for_each = toset(data.aws_availability_zones.zones.names)

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  tags = {
    Name = "web-instance-${each.value}"
  }

  subnet_id = aws_subnet.public_subnet[each.value].id

  availability_zone = each.value
}
