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
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhdHQ0kt282Fbq3lX507dtMToaoFzYvdqeRbRP4Rb0HPQDXjQBRHqwYY46P8x1PirokkLuz8ujGHs9YGl+n2djIcNfty/KKaa76SmVILroCz/6i0S8ucHND4lp++Oa9WcXNaB0StobP7k6/MCIqsPSX93aHHSxj1RACB7Su9QV2gjR4okg55HjUsrby3fuyzAh1r2HhdALtQyj1wNNvRIXnlqscFC1JOYJ2+NB8NHxijCLguehnit9ckzUztHCNT532HWWjn5/vEExePNdV10Jr0FExOK5qtRhVOmotV8VlmcZLPm7V39TxSe6Bligoc0ene74mFRg/BciRHIudfdDw== rsa-key-20190225"

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