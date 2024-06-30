# Define the provider
provider "aws" {
  region = "us-east-1"
}

# Create an IAM group
resource "aws_iam_group" "group" {
  name = var.group_name
}

# Create IAM users and add them to the group
resource "aws_iam_user" "user1" {
  name = var.user_name_1
}

resource "aws_iam_user" "user2" {
  name = var.user_name_2
}

# Create IAM user group membership
resource "aws_iam_user_group_membership" "group_membership_user1" {
  user  = aws_iam_user.user1.name
  groups = [aws_iam_group.group.name]
}

resource "aws_iam_user_group_membership" "group_membership_user2" {
  user  = aws_iam_user.user2.name
  groups = [aws_iam_group.group.name]
}

# Attach a policy to the group
resource "aws_iam_group_policy" "group_policy" {
  group = aws_iam_group.group.name
  
 policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    }
  ]
}
EOF
}