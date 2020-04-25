// Configure the Google Cloud provider
provider "google" {
 credentials = file("terraformtest-eb84996021bb.json")
 project     = "terraformtest-275313"
 region      = "us-central1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "website-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-central1-a"
 tags = ["HTTP", "HTTPS"]
 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-2004-lts"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

 metadata = {
   ssh-keys = "19dan89:${file("~/.ssh/id_rsa.pub")}"
 }
}
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
