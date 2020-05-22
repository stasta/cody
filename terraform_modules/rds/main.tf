resource "aws_db_instance" "db_instance" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"

  //  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = ["${var.primary_subnet}", "${var.secondary_subnet}"]
}
