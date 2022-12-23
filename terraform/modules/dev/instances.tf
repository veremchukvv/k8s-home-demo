resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "private_key" {
  template = file("${path.module}/files/startup.sh")

  vars = {
    tls_private_key = tls_private_key.ssh.private_key_pem
  }
  depends_on = [tls_private_key.ssh]
}

resource "google_compute_instance" "master1" {
  depends_on = [data.template_file.private_key]
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

  metadata = {
    startup-script = data.template_file.private_key.rendered
    ssh-keys       = "root:${tls_private_key.ssh.public_key_openssh}"
  }

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

  metadata = {
    ssh-keys = "root:${tls_private_key.ssh.public_key_openssh}"
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
  metadata = {
    ssh-keys = "root:${tls_private_key.ssh.public_key_openssh}"
  }
}

data "template_file" "hosts" {
  template = file("${path.module}/files/hosts.ini")

  vars = {
    kubernetes_master1_ip = google_compute_instance.master1.network_interface.0.network_ip
    kubernetes_slave1_ip  = google_compute_instance.slave1.network_interface.0.network_ip
    kubernetes_slave2_ip  = google_compute_instance.slave2.network_interface.0.network_ip
  }

}

data "template_file" "k8s_nodes" {
  template = file("${path.module}/files/k8s-cluster.yml")

  vars = {
    kubernetes_master1_ext_ip = google_compute_instance.master1.network_interface.0.access_config.0.nat_ip
    kubernetes_slave1_ext_ip  = google_compute_instance.slave1.network_interface.0.access_config.0.nat_ip
    kubernetes_slave2_ext_ip  = google_compute_instance.slave2.network_interface.0.access_config.0.nat_ip
  }

}

resource "time_sleep" "wait_for_master_creation" {
  create_duration = "1m"

  depends_on = [google_compute_instance.master1
  ]
}

resource "null_resource" "file_upload" {

  depends_on = [
    time_sleep.wait_for_master_creation
  ]

  connection {
    host        = google_compute_instance.master1.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.ssh.private_key_pem
    agent       = false
  }

  provisioner "file" {
    content     = data.template_file.k8s_nodes.rendered
    destination = "/root/k8s-home-demo/kubespray/inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml"
  }

  provisioner "file" {
    content     = data.template_file.hosts.rendered
    destination = "/root/k8s-home-demo/kubespray/inventory/mycluster/hosts.ini"
  }
}