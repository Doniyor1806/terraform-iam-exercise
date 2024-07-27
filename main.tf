terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_iam_group" "default" {
  for_each = toset(keys(local.groups_and_users))
  name     = each.value

}


locals {
  groups_and_users = {
    "Sysadmin" = ["sysadmin1", "sysadmin2"]
    "DBadmin"  = ["dbadmin1", "dbadmin2"]
    "Monitor"  = ["monitor1", "monitor2", "monitor3", "monitor4"]
    "Tester"   = ["tester1", "tester2"]

  }
  group_list = keys(local.groups_and_users)
  user_list  = flatten(values(local.groups_and_users))

}

#Createing Group Membership
resource "aws_iam_group_membership" "my_team" {
  for_each = tomap(local.groups_and_users)
  group    = aws_iam_group.default[each.key].name
  users    = each.value
  name     = each.key
}


#Creating Variable for group policy
variable "iam_group_policies" {
  type = map(string)
  default = {
    "Sysadmin" = "arn:aws:iam::aws:policy/AdministratorAccess"
    "DBadmin"  = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
    "Monitor"  = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    "Tester"   = "arn:aws:iam::aws:policy/aws-service-role/AWSServiceRolePolicyForBackupRestoreTesting"
  }

}


resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  for_each   = var.iam_group_policies
  group      = aws_iam_group.default[each.key].name
  policy_arn = each.value
}



# #Creating Group Policy
# resource "aws_iam_group_policy_attachment" "sysadmin_full_access" {
#   group      = aws_iam_group.default["Sysadmin"].name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

# }

# resource "aws_iam_group_policy_attachment" "dbadmin_full_access" {
#   group      = aws_iam_group.default["DBadmin"].name
#   policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"

# }


# resource "aws_iam_group_policy_attachment" "monitor_read_only" {
#   group      = aws_iam_group.default["Monitor"].name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

# }

# resource "aws_iam_group_policy_attachment" "testing_only" {
#   group      = aws_iam_group.default["Tester"].name
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSServiceRolePolicyForBackupRestoreTesting"

# }




# #Creating System Administrator Group (SysAdmin): 2 users
# variable "admin_users" {
#   type    = list(string)
#   default = ["sysadmin1", "sysadmin2"]

# }

# #Creating Database Administrator Group (DBAdmin): 2 users
# variable "db_admin" {
#   type    = list(string)
#   default = ["dbadmin1", "dbadmin2"]

# }

# #Creating Monitoring Group (Monitor): 4 users. To monitor infrastructure resources
# variable "monitor_users" {
#   type    = list(string)
#   default = ["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"]

# }

# output "aws_iam_group" {
#   value = var.aws_iam_group

# }


# resource "aws_iam_group" "sysadmin_group" {
#   name = "Sysadmin"

# }

# resource "aws_iam_group" "dbadmin_group" {
#   name = "DBAdmin"

# }

# resource "aws_iam_group" "monitor_group" {
#   name = "Monitor"

# }
