resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    "Name"        = var.dynamodb_table_name
    "Description" = "DynamoDB terraform table to lock states"
  }
}
