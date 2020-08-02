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

  //TODO add backup and maintenance options

  skip_final_snapshot       = true     //TODO
  final_snapshot_identifier = "ignore" //TODO
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

resource "aws_security_group_rule" "db_security_group_whitelisted_ips" {
  from_port = 3306
  protocol = "TCP"
  security_group_id = "${aws_security_group.db_security_group.id}"
  to_port = 3306
  type = "ingress"

  count = "${length(var.whitelisted_ips) > 0 ? 1 : 0}"
  cidr_blocks = [ "${var.whitelisted_ips}"]
}
