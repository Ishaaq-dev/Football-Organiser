resource "aws_db_instance" "football_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "football_organiser"
  username             = "master"
  password             = "football"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  identifier           = "football-organiser-db"
}

# add cloudwatch rules here
# need to create the cloudwatch lambdas that will be invoked by the cw rule
# which will then invoke all the lambdas that need to be invoked at the particular moment
