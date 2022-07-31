resource "random_password" "rds_password"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_db_instance" "football_organiser_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "football_organiser"
  username             = "root"
  password             = random_password.rds_password.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  identifier           = "football-organiser-db"
  publicly_accessible  = true
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds_credentials"
  description = "Access to Football_Organiser MySQL Database"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "username": "${aws_db_instance.football_organiser_db.username}",
  "password": "${aws_db_instance.football_organiser_db.password}",
  "engine": "${aws_db_instance.football_organiser_db.engine}",
  "host": "${aws_db_instance.football_organiser_db.address}",
  "port": ${aws_db_instance.football_organiser_db.port},
  "dbname": ${aws_db_instance.football_organiser_db.name}
  "dbInstanceIdentifier": "${aws_db_instance.football_organiser_db.identifier}"
}
EOF
}

# add cloudwatch rules here
# need to create the cloudwatch lambdas that will be invoked by the cw rule
# which will then invoke all the lambdas that need to be invoked at the particular moment
locals {
  username = aws_db_instance.football_organiser_db.username
  password = aws_db_instance.football_organiser_db.password
}

data "atlas_schema" "schema_data" {
  dev_db_url = "mysql://${local.username}:${local.password}@${aws_db_instance.football_organiser_db.endpoint}"
  src        = file("${path.module}/schema/schema.hcl")
}

// Sync the state of the target database with the hcl file.
resource "atlas_schema" "schema" {
  hcl        = data.atlas_schema.schema_data.hcl
  url        = "mysql://${local.username}:${local.password}@${aws_db_instance.football_organiser_db.endpoint}"
  dev_db_url = "mysql://${local.username}:${local.password}@${aws_db_instance.football_organiser_db.endpoint}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-1.com.amazonaws.region.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_tls.id,
  ]

  private_dns_enabled = true
}