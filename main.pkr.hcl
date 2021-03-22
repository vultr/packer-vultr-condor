source "vultr" "debian_10" {
  api_key              = var.vultr_api_key
  os_id                = var.os_id
  plan_id              = var.machine_type
  region_id            = var.region_id
  snapshot_description = "${var.description}-${var.condor_image_version}"
  ssh_username         = "root"
  state_timeout        = var.state_timeout
}

build {
  sources = ["source.vultr.debian_10"]

  provisioner "file" {
    source      = "files/condor-boot.service"
    destination = "/etc/systemd/system/condor-boot.service"
  }

  provisioner "file" {
    source      = "files/condor-boot.sh"
    destination = "/usr/local/bin/condor-boot.sh"
  }

  provisioner "shell" {
    script = "scripts/condor-provision.sh"
    environment_vars = [
      "CONTAINERD_RELEASE=${var.containerd_release}",
      "K8_VERSION=${var.k8_version}"
    ]
  }
}
