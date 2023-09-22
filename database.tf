resource "aws_db_instance" "default" {
allocated_storage = 20
identifier = "prodinstance"
storage_type = "gp2"
engine = "mysql"
engine_version = "5.7"
instance_class = "db.t3.micro"
name = "proddb"
username = "admin"
password = "Admin54132"
parameter_group_name = "default.mysql5.7"
skip_final_snapshot  = true
final_snapshot_identifier  = true
}