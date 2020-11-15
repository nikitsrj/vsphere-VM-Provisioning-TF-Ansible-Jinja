
data "vsphere_datacenter" "dc" {
  name = "KBT-DC"
}

#  resource "vsphere_folder" "terraform_deployed" {
#    path = "nicksrj"
#    type = "vm"
#    datacenter_id = data.vsphere_datacenter.dc.id
#  }

# module "smbc-linuxvm-advanced1" {
#   source                 = "../terraform-vsphere-vm"
#   dc                     = "KBT-DC"
#   vmrp                   = "nikit-smbc-poc"
#   vmfolder               = "nicksrj"
#   datastore              = "VNX-LUN8"
#   vmtemp                 = "smbc-linux-template"
#   cpu_number             = 2
#   ram_size               = 2096
#   #cpu_hot_add_enabled    = "true"
#   #cpu_hot_remove_enabled = "true"
#   #memory_hot_add_enabled = "true"
#   vmname                 = "smbcnickvm"
#   vmdomain               = "terraform.smbc"
#   vmnameliteral          = "smbc-terraform-test"
#   #network_cards          = ["DPG-VLAN32"]
#   network_cards          = ["KBT-DPG-VL32"]
#   ipv4submask            = ["24"]
#   ipv4 = {
#     "KBT-DPG-VL32" = ["10.68.32.123"] 
#   }
#   data_disk_size_gb = [10, 5] // Aditional Disk to be used
#   thin_provisioned  = ["true", "true"]
#   vmdns             = ["8.8.8.8"]
#   vmgateway         = "10.68.32.1"
# }

# resource "null_resource" "ansible1" {
#   depends_on = [null_resource.disk-format1]
#   provisioner "local-exec" {
#     command = "sleep 20 && ansible-playbook ansible.yaml -i 10.68.32.123, -e  'ansible_user=root ansible_password=redhat ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
#     interpreter = ["/bin/bash", "-c"]
#   }
# }


module "Server_01" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "KBT-DC"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  disk_datastore         = "VNX-LUN8"
  cpu_number             = 2
  ram_size               = 2096
  #cpu_hot_add_enabled    = "true"
  #cpu_hot_remove_enabled = "true"
  #memory_hot_add_enabled = "true"
  vmname                 = "smbcnickvm2"
  vmdomain               = "terraform.smbc"
  vmnameliteral          = "smbc-terraform-test2"
  network_cards          = ["KBT-DPG-VL32"]
  ipv4submask            = ["24"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.123"] 
  }
  # scsi_type = "lsilogic-sas" # "pvscsi"
  # scsi_controller = 0
  data_disk_size_gb = [
  10,
  5,
  ] // Aditional Disk to be used
  thin_provisioned  = ["true", "true"]
  vmdns             = ["8.8.8.8"]
  vmgateway         = "10.68.32.1"
  vmtemp            = "${var.linux_temp}"
  tags = {
    "VM_Type"    = "Application"
  }
}


resource "null_resource" "ansible2" {
  depends_on = [module.Server_01]
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook postprovisioning.yaml -i 10.68.32.123, -e  'ansible_user=root ansible_password=${var.linux_temp_passwd} ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
    interpreter = ["/bin/bash", "-c"]
  }
}

module "Server_02" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "KBT-DC"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  instances              = 1
  cpu_number             = 4
  ram_size               = 6144
  cpu_hot_add_enabled    = "true"
  cpu_hot_remove_enabled = "true"
  memory_hot_add_enabled = "true"
#  vmname                 = "smbc-terraform-win2016"
#  vmnamesuffix           = ""
  vmnameliteral          = "smbc-terraform-win"
  vmdomain               = "somedomain.com"
  network_cards          = ["KBT-DPG-VL32"]
  ipv4submask            = ["24"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.125"] // Here the first instance will use Static Ip and Second DHCP
  }
  scsi_type = "lsilogic-sas" # "pvscsi"
  scsi_controller = 0
 # data_disk_scsi_controller  = [0, 3]
  disk_datastore             = "VNX-LUN9"
#  data_disk_datastore        = ["vsanDatastore", "nfsDatastore"]
  data_disk_size_gb = [
  10,
  5,
  ] // Aditional Disks to be used
  thin_provisioned  = ["true", "true"]
  vmdns             = ["8.8.8.8"]
  vmgateway         = "10.68.32.1"
  vmtemp            = "${var.windows_temp}"
  tags = {
    "VM_Type"    = "DB"
  }
  enable_disk_uuid = "true"
  auto_logon       = "true"
  run_once         = ["powershell -Command echo 'Get-Disk | Where-Object PartitionStyle -eq RAW | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false' > C:\\format-mount.ps1",  "powershell -ExecutionPolicy Unrestricted -File C:\\format-mount.ps1 -Schedule"] 
 # orgname          = "Terraform-Module"
  workgroup        = "terraform-Test"
  is_windows_image = "true"
  # windomain             = "Development.com"
  # domain_admin_user     = "Domain admin user"
  # domain_admin_password = "SomePassword"
  firmware         = "efi"
  local_adminpass  = "${var.windows_temp_passwd}"
} 

