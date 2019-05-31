resource "google_compute_instance" "wordpress" {
  //インスタンス名、マシンタイプ、作成するゾーンの選択
  name         = "${var.userName}"
  machine_type = "f1-micro"
  zone         = "${var.region_zone}"

  //ネットワークタグを記載
  tags = ["http-server"]

  //立ち上げるOSを選択。
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size  = "10"
    }
  }

  //プリミティブVMとして作成
  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  //ネットワークインタフェース情報を記載。
  //IPアドレス固定化等設定
  network_interface {
    network = "training"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    "block-project-ssh-keys" = "true"
    "sshKeys"                = "${var.wp_ssh_keys}"
  }

  //service_accountの設定
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

