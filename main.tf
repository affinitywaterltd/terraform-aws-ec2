resource "aws_instance" "default" {
  ami                                  = var.ami
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.ssh_key_pair
  monitoring                           = var.monitoring
  vpc_security_group_ids               = var.security_groups_ids
  subnet_id                            = var.subnet_id
  private_ip                           = var.private_ip
  associate_public_ip_address          = var.associate_public_ip_address
  source_dest_check                    = var.source_dest_check
  user_data                            = var.user_data
  iam_instance_profile                 = var.iam_role
  tags                                 = var.tags


  volume_tags                          = var.tags
  hibernation = var.hibernation

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
    encrypted             = var.encrypted
    kms_key_id            = var.kms_key_id
    iops                  = contains(["gp3", "io1", "io2"], var.root_volume_type) ? var.root_volume_iops : null
    throughput            = contains(["gp3"], var.root_volume_type) ? var.root_volume_throughput : null
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      root_block_device
    ]
  }
}

resource "aws_ebs_volume" "default" {
  count             = var.is_gp3_test == false ? length(var.ebs_volumes) : 0 #length of volumes list
  availability_zone = local.availability_zone
  size              = element(var.ebs_volumes, count.index)     #index count
  type              = element(var.ebs_volume_type, count.index) #index count

  #type              = "${var.ebs_volume_type}"
  tags      = var.tags
  encrypted = var.ebs_volume_encrypted
}

resource "aws_volume_attachment" "default" {
  count       = length(var.ebs_volumes)
  device_name = element(var.ebs_device_name, count.index)
  volume_id   = element(aws_ebs_volume.default.*.id, count.index)
  instance_id = aws_instance.default.id
}


resource "aws_ebs_volume" "gp3" {
  count             = var.is_gp3_test == true ? length(var.ebs) : 0 #length of volumes list
  availability_zone = local.availability_zone


  size              = element(var.ebs, count.index).values.size    #index count
  type              = element(var.ebs, count.index).values.type #index count

  #type              = "${var.ebs_volume_type}"
  tags      = var.tags
  encrypted = var.ebs_volume_encrypted
}