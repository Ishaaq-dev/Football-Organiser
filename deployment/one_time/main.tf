resource "aws_db_instance" "football_organiser_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "football_organiser"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  identifier           = "football-organiser-db"
  publicly_accessible  = true
}

# add cloudwatch rules here
# need to create the cloudwatch lambdas that will be invoked by the cw rule
# which will then invoke all the lambdas that need to be invoked at the particular moment


data "atlas_schema" "schema_data" {
  dev_db_url = "mysql://${var.username}:${var.password}@${aws_db_instance.football_organiser_db.endpoint}"
  src        = file("${path.module}/schema/schema.hcl")
}

// Sync the state of the target database with the hcl file.
resource "atlas_schema" "schema" {
  hcl        = data.atlas_schema.schema_data.hcl
  url        = "mysql://${var.username}:${var.password}@${aws_db_instance.football_organiser_db.endpoint}"
  dev_db_url = "mysql://${var.username}:${var.password}@${aws_db_instance.football_organiser_db.endpoint}"
}
