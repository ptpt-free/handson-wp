resource "google_compute_instance_group" "wp_group" {
  //インスタンスグループ名、ゾーン、対象インスタンスの設定
  name        = "ig${var.userNumber}"
  description = "handson wordpress instance group"
  zone        = "${var.region_zone}"

  named_port = {
    name = "http"
    port = "80"
  }

  instances = [
    "${google_compute_instance.wordpress.self_link}",
  ]
}
