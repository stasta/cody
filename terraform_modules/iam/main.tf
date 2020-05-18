resource "aws_iam_account_password_policy" "password_policy" {
  allow_users_to_change_password = true
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers = true
  require_symbols = true
  password_reuse_prevention = 10
  minimum_password_length = 12
}

resource "aws_iam_account_alias" "account_alias" {
  account_alias = "${var.account_alias}"
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
}

resource "aws_iam_user" "administrator_users" {
  count = "${length(var.administrator_users)}"
  name = "${element(var.administrator_users,count.index )}"
}

# Iterates over the list "administrator_users"
# and add each of them to group administrators
resource "aws_iam_group_membership" "administrators-users" {
  count = "${length(var.administrator_users)}"

  group = "${aws_iam_group.administrators.name}"
  name  = "administrators-membership"

  users = ["${element(aws_iam_user.administrator_users.*.name,count.index )}"]
}

resource "aws_iam_group_policy_attachment" "administrators-policy" {
  group = "${aws_iam_group.administrators.name}"
  policy_arn = "${data.aws_iam_policy.administrator-access-policy.arn}"
}

data "aws_iam_policy" "administrator-access-policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}