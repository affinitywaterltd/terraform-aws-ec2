# AWS Elastic Cloud Compute (EC2) Terraform module

Terraform module which creates EC2 resources on AWS.

This module focuses on EC2 Instance, EBS Volumes and EBS Volume Attachments.

* [EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
* [EBS Volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume)
* [EBS Volume Attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment)


This Terraform module will provide the required resources for an EC2 instance and all the required resources.

## Terraform versions

Terraform ~> 0.12

## Usage

Windows Example with minimum required and useful settings options
```hcl
module "ec2" {
  source        = "github.com/affinitywaterltd/terraform-aws-ec2"
  ami           = local.windows2019_ami
  iam_role      = local.ssm_role
  instance_type = "t3.small"
  user_data     = local.windows_user_data

  subnet_id = local.priv_a
  
  security_groups_ids = [
    local.admin_sg,
    local.remote_access_sg
  ]
  
  root_volume_size = 50
  /*ebs_volumes = [
    {
      size = 2
      type = "gp3"
    },
    {
      size = 3
      type = "gp3"
      iops = 3500 # max 500 per GB (Default 3000)
      throughput = 150 # max 250 (Default 125)
    },
    {
      size = 1 # Defaults to standard if no type is specified
    }
  ]*/
  
  tags = merge(
    local.common_tags,
    {
      "ApplicationType"      = "Application"
      "Name"                 = ""
      "Description"          = ""
      "OperatingSystem"      = "Windows Server 2019"
      "aws_backup_plan_daily_2200_30days" = "true"
      "Schedule"             = "ec2:0800-1700:mon-fri"
      "CreationDate"         = ""
      "ssmMaintenanceWindow" = "aws_week-2_wed_2200"
      "ssmNotification"      = "[email]:[email]:[email]"
    },
  )
}
```

Windows Example with minimum required and useful settings options
```hcl
module "ec2" {
  source        = "github.com/affinitywaterltd/terraform-aws-ec2"
  ami           = local.awslinux2_ami
  iam_role      = local.ssm_role
  instance_type = "t3.small"
  user_data     = local.linux_user_data

  subnet_id = local.priv_a

  security_groups_ids = [
    local.admin_sg,
    local.remote_access_sg
  ]
  
  root_volume_size = 50
  /*ebs_volumes = [
    {
      size = 2
      type = "gp3"
    },
    {
      size = 3
      type = "gp3"
      iops = 3500 # max 500 per GB (Default 3000)
      throughput = 150 # mac 250 (Default 125)
    },
    {
      size = 1 # Defaults to standard if no type is specified
    }
  ]*/

  tags = merge(
    local.common_tags,
    {
      "ApplicationType"      = "Application"
      "Name"                 = ""
      "Description"          = ""
      "OperatingSystem"      = "Amazon Linux 2"
      "aws_backup_plan_daily_2200_30days" = "true"
      "Schedule"             = "ec2:0800-1700:mon-fri"
      "CreationDate"         = ""
      "ssmMaintenanceWindow" = "aws_linux_week-2_wed_2200"
    },
  )
}
```

## Conditional creation

This EC2 module does not have conditional creation of the EC2 instance

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iam_role | The IAM role to be attached to the instance | `string` | `EC2_SSM_Role` | no |
| user_data | Instance user data. Do not pass gzip-compressed data via this argument | `string` | `""` | no |
| ami | The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04 | `string` | `""` | yes |
| instance_type | The type of the instance | `string` | `t2.micro` | no |
| security_groups_ids | List of Security Group IDs allowed to connect to the instance | `list(string)` | `null` | no |
| subnet_id | VPC Subnet ID the instance is launched in | `string` | `none` | yes || root_volume_type | Type of root volume. Can be standard, gp2 or io1 | `string` | `standard` | no |
| root_volume_iops | Provisioned IOPS of root volume. Used for gp3, io1 and io2 | `number` | `0` | no |
| root_volume_throughput | Provisioned Throughput of root volume. Used for gp3 | `number` | `0` | no |
| root_volume_size | Size of the root volume in gigabytes | `number` | `10` | no |
| ebs_device_name | Name of the EBS device to mount | `list(string)` | `["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]` | no |
| ebs_volume_type | The type of EBS volume. Can be standard, gp2 or st1 | `list` | `[]` | no |
| ebs_volume_encrypted | Whether the attached EBS Volumes are encrypted | `bool` | `true` | no |
| ebs_volumes | Contains a list of objects with the volume definitions (ebs_volumes = [{size = 2, type = "gp3" }] or a list with the size of the EBS volumes in gigabytes (ebs_volumes = [10, 20, 30]) | `any` | `[]` | no |
| availability_zone | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region | `string` | `none` | yes |
| ebs_optimized | Launched EC2 instance will be EBS-optimized | `bool` | `true` | no |
| disable_api_termination | Enable EC2 Instance Termination Protection | `bool` | `false` | no |
| vpc_id | The ID of the VPC that the instance security group belongs to | `string` | `""` | no |
| ssh_key_pair | SSH key pair to be provisioned on the instance | `string` | `AWDefault` | no |
| delete_on_termination | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| cpu_credits | Sets whether T2/T3 Unlimited is configured and standard or unlimited for the credit_specification | `string` | `standard` | no |
| associate_public_ip_address | Associate a public ip address with an instance in a VPC. Boolean value.. | `bool` | `false` | no |
| source_dest_check | Default Network Interface config for source dest check. Boolean value. | `bool` | `true` | no |
| monitoring | Enable cloudwatch detailed monitoring metrics. Boolean value. | `bool` | `false` | no |
| placement_group | The Placement Group to start the instance in. | `string` | `""` | no |
| tenancy | An instance with a tenancy of dedicated runs on single-tenant hardware. | `string` | `default` | no |
| instance_initiated_shutdown_behavior | Shutdown behaviour for the instance. | `string` | `""` | no |
| root_volume_encrypted | Enable volume encryption of the root volume. | `bool` | `true` | no |
| kms_key_id | KMS Key to use when encrypting the volume. | `string` | `""` | no |
| hibernation | The launched EC2 instance will support hibernation. | `bool` | `false` | no |
| private_ip | (Optional) Private IP address to associate with the instance in a VPC. | `string` | `null` | no |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iam_role | The IAM role to be attached to the instance | `string` | `EC2_SSM_Role` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2_id | Disambiguated ID of the instance |
| private_ip | Private IP of instance |