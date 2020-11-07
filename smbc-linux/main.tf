
data "vsphere_datacenter" "dc" {
  name = "KBT-DC"
}

#  resource "vsphere_folder" "terraform_deployed" {
#    path = "nicksrj"
#    type = "vm"
#    datacenter_id = data.vsphere_datacenter.dc.id
#  }

module "smbc-linuxvm-advanced1" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "KBT-DC"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  datastore              = "VNX-LUN8"
  vmtemp                 = "smbc-linux-template"
  cpu_number             = 2
  ram_size               = 2096
  #cpu_hot_add_enabled    = "true"
  #cpu_hot_remove_enabled = "true"
  #memory_hot_add_enabled = "true"
  vmname                 = "smbcnickvm"
  vmdomain               = "terraform.smbc"
  vmnameliteral          = "smbc-terraform-test"
  #network_cards          = ["DPG-VLAN32"]
  network_cards          = ["KBT-DPG-VL32"]
  ipv4submask            = ["24"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.123"] 
  }
  data_disk_size_gb = [10, 5] // Aditional Disk to be used
  thin_provisioned  = ["true", "true"]
  vmdns             = ["8.8.8.8"]
  vmgateway         = "10.68.32.1"
}

resource "null_resource" "disk-format1" {
 depends_on = [module.smbc-linuxvm-advanced1]
 provisioner "file" {
  source      = "format-mount.sh"
  destination = "/opt/format-mount.sh"

  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "10.68.32.123"
  }
}
  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/format-mount.sh",
      "/bin/bash -x /opt/format-mount.sh",
    ]
    connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "10.68.32.123"
  }
  }
}

resource "null_resource" "ansible1" {
  depends_on = [null_resource.disk-format1]
  provisioner "local-exec" {
    command = "sed -i \"s/SERVER1_IP/10.68.32.123/g\" hosts"
  }
  provisioner "local-exec" {
    command = "sleep 10"
  }
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook ansible.yaml -i 10.68.32.123, -e  'ansible_user=root ansible_password=redhat ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
    interpreter = ["/bin/bash", "-c"]
  }
}


module "smbc-linuxvm-advanced2" {
  source                 = "../terraform-vsphere-vm"
  #vm_depends_on          = [module.smbc-linuxvm-advanced1]
  dc                     = "KBT-DC"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  datastore              = "VNX-LUN8"
  vmtemp                 = "smbc-linux-template"
  cpu_number             = 2
  ram_size               = 2096
  #cpu_hot_add_enabled    = "true"
  #cpu_hot_remove_enabled = "true"
  #memory_hot_add_enabled = "true"
  vmname                 = "smbcnickvm2"
  vmdomain               = "terraform.smbc"
  vmnameliteral          = "smbc-terraform-test2"
  #network_cards          = ["DPG-VLAN32"]
  network_cards          = ["KBT-DPG-VL32"]
  ipv4submask            = ["24"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.124"] 
  }
  data_disk_size_gb = [10, 5] // Aditional Disk to be used
  thin_provisioned  = ["true", "true"]
  vmdns             = ["8.8.8.8"]
  vmgateway         = "10.68.32.1"
}

resource "null_resource" "disk-format2" {
 depends_on = [module.smbc-linuxvm-advanced2]
 provisioner "file" {
  source      = "format-mount.sh"
  destination = "/opt/format-mount.sh"

  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "10.68.32.124"
  }
}
  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/format-mount.sh",
      "/bin/bash -x /opt/format-mount.sh",
    ]
    connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "10.68.32.124"
  }
  }
}

resource "null_resource" "ansible2" {
  depends_on = [null_resource.disk-format2]
  provisioner "local-exec" {
    command = "sed -i \"s/SERVER2_IP/10.68.32.124/g\" hosts2"
  }
  provisioner "local-exec" {
    command = "sleep 10"
  }
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook ansible.yaml -i 10.68.32.124, -e  'ansible_user=root ansible_password=redhat ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
    interpreter = ["/bin/bash", "-c"]
  }
}

