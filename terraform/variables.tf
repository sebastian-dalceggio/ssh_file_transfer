variable "project_name" {
  type        = string
  description = "Project asociated to the resource"
  default     = "ssh_file_transfer"
}

locals {
  envs = { for tuple in regexall("(.*)=(.*)", file("../.env")) : tuple[0] => sensitive(tuple[1]) }
}