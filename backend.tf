

### Variables ##
variable db_storage {
  default = "20"
}

variable db_engine {
  default = "mysql"
}

variable db_instance_type {
  default = "db.t2.micro"
}

variable db_user {
  default = "admin"
}

variable db_password {
  default = "devops2017"
}

# The name of the database is already in the snapshot
variable db_snapshot {
  default = "arn:aws:rds:eu-west-1:159571505100:snapshot:attendeelist"
}

### Resources
resource "aws_db_subnet_group" "mysql" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
  name = "main"
  subnet_ids = ["${element(aws_subnet.public.*.id,0)}", "${element(aws_subnet.public.*.id,1)}"]
}

resource "aws_db_instance" "mysql" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/db_instance.html
  # create the db from the given snapshot
  snapshot_identifier    = "${var.db_snapshot}"
  instance_class       = "${var.db_instance_type}"
  skip_final_snapshot = true
}


### Outputs
output "mysql_host" {
  # TO DO
  # see https://www.terraform.io/intro/getting-started/outputs.html
  value = "${aws_db_instance.mysql.address}"
}

output "mysql_db" {
  # TO DO
  value = "${aws_db_instance.mysql.name}"
}

output "mysql_user" {
  # TO DO
  value = "${var.db_user}"
}

output "mysql_password" {
  # TO DO
  value = "${var.db_password}"
}
