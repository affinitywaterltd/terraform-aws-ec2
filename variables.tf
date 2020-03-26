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

variable "security_groups_ids" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = "list"
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
  default     = "true"
}

variable "disable_api_termination" {
  description = "Enable EC2 Instance Termination Protection"
  default     = "false"
}

variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "standard"
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
  description = "The type of EBS volume. Can be standard, gp2 or st1"
  default     = []
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

variable "cpu_credits" {
  description = "Sets whether T2/T3 Unlimited is configured and standard or unlimited for the credit_specification"
  default     = "standard"
}


variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC. Boolean value."
  default     = "false"
}

variable "source_dest_check" {
  description = "Default Network Interface config for source dest check. Boolean value."
  default     = "true"
}

variable "monitoring" {
  description = "Enable cloudwatch detailed monitoring metrics. Boolean value."
  default     = "false"
}

variable "placement_group" {
  description = "The Placement Group to start the instance in."
  default     = ""
}

variable "tenancy" {
  description = "An instance with a tenancy of dedicated runs on single-tenant hardware."
  default     = "default"
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance."
  default     = ""
}

variable "encrypted" {
  description = "Enable volume encryption."
  default     = "true"
}

variable "kms_key_id" {
  description = "KMS Key to use when encrypting the volume."
  default     = ""
}

variable "hibernation" {
  description = "the launched EC2 instance will support hibernation.."
  default     = "false"
}