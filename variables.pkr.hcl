variable "vultr_api_key" {
  type      = string
  default   = env("VULTR_API_KEY")
  sensitive = true
}

variable "os_id" {
  type        = number
  default     = 352
  description = "Vultr OS ID for base image."
}

variable "machine_type" {
  type        = string
  default     = "vc2-1c-1gb"
  description = "Vultr Machine type to build the snapshot on."
}

variable "region_id" {
  type        = string
  default     = "ewr"
  description = "Vultr region id to deploy build server."
}

variable "hostname" {
  type    = string
  default = "condor"
}

variable "description" {
  type    = string
  default = "condor"
}

variable "containerd_release" {
  description = "Version of Containerd runtime package to install via APT to use on cluster instances. Format should be in APT package version string format: x.y.z-00"
  type        = string
  default     = "1.4.3-1"
}

variable "k8_version" {
  description = "Version of Kubernetes packages to install via APT. Format should be in APT package version string format: x.y.z-00"
  type        = string
  default     = "1.20.2-00"
}

variable "condor_image_version" {
  type    = string
  default = "v1.0.0-1"
}

variable "state_timeout" {
  type    = string
  default = "10m"
}
