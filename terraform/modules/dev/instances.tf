resource "google_compute_instance" "master1" {
  #name         = "${format("%s","${var.company}-${var.env}-${var.region_map["${var.var_region_name}"]}-instance1")}"
  name         = "kubernetes-master1"
  machine_type = "n2-standard-2"
  #zone         =   "${element(var.var_zones, count.index)}"
  #zone          =   "${format("%s","${var.var_region_name}-b")}"
  zone = var.zone
  #tags          = ["ssh","http"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2210-amd64"
      size  = var.disk_size
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }

  scheduling {
    preemptible        = true
    automatic_restart  = false
    provisioning_model = "SPOT"
  }

  # labels {
  #       webserver =  "true"     
  #     }
  # metadata {
  #         startup-script = <<SCRIPT
  #         apt-get -y update
  #         apt-get -y install nginx
  #         export HOSTNAME=$(hostname | tr -d '\n')
  #         export PRIVATE_IP=$(curl -sf -H 'Metadata-Flavor:Google' http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip | tr -d '\n')
  #         echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/www/index.html
  #         service nginx start
  #         SCRIPT
  #     } 
  # network_interface {
  #     subnetwork = "${google_compute_subnetwork.public_subnet.name}"
  #     access_config {
  #       // Ephemeral IP
  #     }
  #   }
}

resource "google_compute_instance" "slave1" {
  name         = "kubernetes-slave1"
  machine_type = "n2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2210-amd64"
      size  = var.disk_size
    }
  }
  network_interface {
    network = var.network
        access_config {
    }
  }

  scheduling {
    preemptible        = true
    automatic_restart  = false
    provisioning_model = "SPOT"
  }
}

resource "google_compute_instance" "slave2" {
  name         = "kubernetes-slave2"
  machine_type = "n2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2210-amd64"
      size  = var.disk_size
    }
  }
  network_interface {
    network = var.network
        access_config {
    }
  }

  scheduling {
    preemptible        = true
    automatic_restart  = false
    provisioning_model = "SPOT"
  }
}