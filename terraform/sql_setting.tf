resource "google_sql_database_instance" "wordpress" {
  //インスタンス名、データベースの種類、リージョンの選択
  name             = "db${var.userNumber}"
  database_version = "MYSQL_5_6"
  region           = "us-east1"

  //作成するインスタンスタイプの選択
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "users" {
  //作成するデータベース名、作成するDBがあるインスタンス、文字コードの選択
  name      = "wordpress"
  instance  = "${google_sql_database_instance.wordpress.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
  //作成するユーザ、ユーザを作成するインスタンス、ユーザが接続できるホスト、パスワードの選択
  name     = "root"
  instance = "${google_sql_database_instance.wordpress.name}"
  host     = "${google_compute_instance.wordpress.name}"
  password = "m,jkui78"
}
