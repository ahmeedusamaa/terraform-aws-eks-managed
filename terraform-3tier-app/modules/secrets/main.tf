resource "aws_secretsmanager_secret" "app-secrets" {
  name        = "app-secrets"
  description = "Secrets for My 3-tier app (MySQL and Redis)"
}

resource "aws_secretsmanager_secret_version" "app-secrets-version" {
  secret_id     = aws_secretsmanager_secret.app-secrets.id
  secret_string = jsonencode({
    MYSQL_USER     = var.mysql_user,
    MYSQL_PASSWORD = var.mysql_password,
    MYSQL_ROOT_PASSWORD = var.mysql_root_password,
    MYSQL_DATABASE = var.mysql_database,
    MYSQL_HOST     = var.mysql_host,
    MYSQL_PORT     = var.mysql_port,
    REDIS_HOST     = var.redis_host,
    REDIS_PORT     = var.redis_port,
    REDIS_PASSWORD = var.redis_password
  })
}


