module "SNGP1VLDSBOC01" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "SGDC VSI Cluster"
  network_cards          = ["VLAN28"]
  ipv4 = {
    "VLAN28" = ["10.117.254.25"]
  }
  ipv4submask            = ["24"]
  vmdns                  = ["10.118.76.34"]
  vmgateway              = "10.118.76.1"
  vmrp                   = "nicksrj"
  vmfolder               = "nicksrj"
  disk_datastore         = "IDS-G400-VS-DC-DE-T2-P01-NR02"
  cpu_number             = 4
  ram_size               = 65536
  # cpu_hot_add_enabled    = "true"
  # cpu_hot_remove_enabled = "true"
  # memory_hot_add_enabled = "true"
  vmdomain               = "somedomain.com"
  vmnameliteral          = "SNGP1VLDSBOC01"
  scsi_type = "lsilogic-sas"
  scsi_controller = 0
  # data_disk_scsi_controller  = [0, 3]
  # data_disk_datastore        = ["vsanDatastore", "nfsDatastore"]
  data_disk_size_gb = [
  100, 
  30, 
  20, 
  ]

  thin_provisioned  = [
  "true",
  "true",
  "true"
  ]
  tags = {
    "VM_Type"    = "DB"
    }
  vmtemp            = "${var.linux_temp}"
 }
resource "null_resource" "SNGP1VLDSBOC01" {
  depends_on = [module.SNGP1VLDSBOC01]
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook postprovisioning.yaml -i 10.117.254.25, -e  'ansible_user=root ansible_password=${var.linux_temp_passwd} ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
    interpreter = ["/bin/bash", "-c"]
  }
 }
module "SNGP2VWWSWOC02" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "SGDR VSI Cluster02"
  network_cards          = ["VLAN8"]
  ipv4 = {
    "VLAN8" = ["10.117.254.26"]
  }
  ipv4submask            = ["24"]
  vmdns                  = ["10.118.76.34"]
  vmgateway              = "10.118.76.1"
  vmrp                   = "nicksrj"
  vmfolder               = "nicksrj"
  disk_datastore         = "HDS-G400-VS-DC-DE-T2-P01-NR02"
  cpu_number             = 4
  ram_size               = 65536
  # cpu_hot_add_enabled    = "true"
  # cpu_hot_remove_enabled = "true"
  # memory_hot_add_enabled = "true"
  vmdomain               = "somedomain.com"
  vmnameliteral          = "SNGP2VWWSWOC02"
  scsi_type = "lsilogic-sas"
  scsi_controller = 0
  # data_disk_scsi_controller  = [0, 3]
  # data_disk_datastore        = ["vsanDatastore", "nfsDatastore"]
  data_disk_size_gb = [
  50, 
  20, 
  90, 
  ]

  thin_provisioned  = [
  "true",
  "true",
  "true"
  ]
  tags = {
    "VM_Type"    = "WebServer"
    }
  vmtemp            = "${var.windows_temp}"
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

