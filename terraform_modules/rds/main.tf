resource "aws_db_instance" "db_instance" {
  identifier_prefix = "wordpress-db" //TODO

  allocated_storage    = 5 //TODO
  storage_type         = "gp2"
  engine               = "mysql" //TODO
  engine_version       = "5.7" //TODO
  instance_class       = "db.t2.micro" //TODO
  name                 = "mydb" //TODO
  username             = "foo" //TODO
  password             = "foobarbaz" //TODO
  parameter_group_name = "default.mysql5.7"

  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.name}"
  publicly_accessible = true

  skip_final_snapshot  = true
  final_snapshot_identifier = "ignore"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = ["${var.primary_subnet}", "${var.secondary_subnet}"]
}
