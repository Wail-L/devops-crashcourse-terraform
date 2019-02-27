### Variables
variable front_instance_number {
  default = "2"
}

variable front_ami {
  default = "ami-0d77397e" # Ubuntu 16.04
}

variable front_instance_type {
  default = "t2.micro"
}

variable public_key {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJ6RTIUF2qIudJuRiyznZp4U7YUcMCTygJxMXQKCICT5ir+sLxwtQNvTfd1LVz3RLMYNx768SlikhtO/9eFzjf/rpHs2RwDoaW8vyTg41Hsmc9GJ7klNkUsiO7MhgsO8AEkStTOaHqH6zLUA7FTG3m4FbY74/U8MdMTwQih97CLKJgItmH7wy0mRoWwQnxUth7wP8iaN9aJcEWn5DbhIK1W91Kjr86uFbN9xf5jOval1Qzd7UlBcwV4wEm2VKWSyuiiR0+Qgo82gOi2QXMCk/GUkGzeVK6gWZgasQlUgiRSeVvqVf3El+wayK7I8eH0SDJlaGUQrFInbgxlAfo98Rp imported-openssh-key"
}

variable front_elb_port {
  default = "80"
}

variable front_elb_protocol {
  default = "http"
}

### Resources
resource "aws_key_pair" "front" {
  key_name   = "${var.project_name}-front"
  public_key = "${var.public_key}"
}

data "template_file" "init" {
  template = "${file("init.tpl")}"
}

resource "aws_instance" "front" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/instance.html
  ami           = "${var.front_ami}"
  instance_type = "t2.micro"
  key_name = "devops-crashcourses-front"
  user_data = "${data.template_file.init.rendered}"
}

resource "aws_elb" "front" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/elb.html
  availability_zones = "${var.azs[var.region]}"

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }
  instances                   = ["${aws_instance.front.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}


### Outputs
output "elb_endpoint" {
  # TO DO
  # see https://www.terraform.io/intro/getting-started/outputs.html
  value = "${aws_elb.front.id}"
}

output "instance_ip" {
  # TO DO
  value = "${aws_instance.front.public_ip}"
}