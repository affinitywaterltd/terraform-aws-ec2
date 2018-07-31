data "aws_subnet" "default" {
  id = "${var.subnet_id}"
}
data "aws_caller_identity" "default" {}

locals {
  availability_zone = "${var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone}"
  vpc_id            = "${var.vpc_id != "" ? var.vpc_id : data.aws_subnet.default.vpc_id}"
}

variable "ssh_key_pair" {
  description = "SSH key pair to be provisioned on the instance"
  default     = "AWDefault"
}

variable "iam_role" {
  description = "The IAM role to be attached to the instance"
  default     = "EC2_SSM_Role"
}


variable "user_data" {
  description = "Instance user data. Do not pass gzip-compressed data via this argument"
  default     = ""
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  default     = ""
}

variable "security_groups" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = "list"
  default     = []
}

variable "subnet_id" {
  description = "VPC Subnet ID the instance is launched in"
}

variable "tags" {
  description = "Additional tags"
  type        = "map"
  default     = {}
}

variable "availability_zone" {
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = ""
}

variable "ami" {
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"
  default     = ""
}

variable "ebs_optimized" {
  description = "Launched EC2 instance will be EBS-optimized"
  default     = "false"
}

variable "disable_api_termination" {
  description = "Enable EC2 Instance Termination Protection"
  default     = "false"
}

variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  default     = "10"
}

variable "ebs_device_name" {
  type        = "list"
  description = "Name of the EBS device to mount"
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}

variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "ebs_volumes" {
  description = "Size of the EBS volumes in gigabytes"
  type        = "list"
  default     = []
}

variable "delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  default     = "true"
}
