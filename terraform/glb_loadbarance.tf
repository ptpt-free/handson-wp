resource "google_compute_http_health_check" "wp-health-check" {
  //ヘルスチェックの設定名、設定ポート、リクエストパス、リクエスト、応答時間の選択
  name               = "hc${var.userNumber}"
  port               = "80"
  request_path       = "/"
  check_interval_sec = 2
  timeout_sec        = 2
}

resource "google_compute_backend_service" "wp-be-lb" {
  //バックエンドサービスで必要な各種設定の選択
  name             = "be${var.userNumber}"
  health_checks    = ["${google_compute_http_health_check.wp-health-check.self_link}"]
  timeout_sec      = 10
  session_affinity = "NONE"
  port_name        = "http"
  protocol         = "HTTP"

  backend {
    group = "${google_compute_instance_group.wp_group.self_link}"
  }
}

resource "google_compute_global_forwarding_rule" "wp-int-lb-forwarding-rule" {
  //フロントエンド側で必要な各種設定の選択
  name       = "fe${var.userNumber}"
  port_range = "80"
  target     = "${google_compute_target_http_proxy.frontend.self_link}"
}

resource "google_compute_target_http_proxy" "default" {
  //HTTPポリシーの呼び出し
  name    = "wp${var.userNumber}-proxy"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_target_http_proxy" "frontend" {
  //HTTPポリシーの呼び出し
  name    = "fe${var.userNumber}-proxy"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  //HTTPポリシーの設定
  name            = "lb${var.userNumber}"
  default_service = "${google_compute_backend_service.wp-be-lb.self_link}"

  host_rule {
    hosts        = ["wp${var.userNumber}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.wp-be-lb.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.wp-be-lb.self_link}"
    }
  }
}
