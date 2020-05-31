resource "aws_db_instance" "db_instance" {
  identifier_prefix = "wordpress-db" //TODO

  allocated_storage    = 5                  //TODO
  storage_type         = "gp2"
  engine               = "mysql"            //TODO
  engine_version       = "5.7"              //TODO
  instance_class       = "db.t2.micro"      //TODO
  name                 = "mydb"             //TODO
  username             = "foo"              //TODO
  password             = "foobarbaz"        //TODO
  parameter_group_name = "default.mysql5.7"

  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.name}"
  publicly_accessible  = true

  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]

  skip_final_snapshot       = true
  final_snapshot_identifier = "ignore"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = ["${var.subnets}"]
}

resource "aws_security_group" "db_security_group" {
  name_prefix = "db-sg-"
  description = "Allows traffic on DB port"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    protocol        = "TCP"
    to_port         = 3306
    security_groups = ["${var.allowed-sgs}"]
  }

  egress {
    from_port   = 3306
    protocol    = "TCP"
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }
}
