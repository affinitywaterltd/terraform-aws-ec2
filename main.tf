resource "aws_instance" "default" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  subnet_id = "${var.subnet_id}"

  iam_instance_profile = "${var.iam_role}"

  security_groups = ["${var.security_groups}"]

  key_name = "${var.ssh_key_pair}"
  root_block_device {
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
    volume_type           = "${var.ebs_volume_type}"
  }
  tags = "${var.tags}"
}

resource "aws_ebs_volume" "default" {
  count             = "${length(var.ebs_volumes)}"               #length of volumes list
  availability_zone = "${local.availability_zone}"
  size              = "${element(var.ebs_volumes, count.index)}" #index count
  type              = "${var.ebs_volume_type}"
  tags              = "${var.tags}"
  encrypted         = true
}

resource "aws_volume_attachment" "default" {
  count       = "${length(var.ebs_volumes)}"
  device_name = "${element(var.ebs_device_name, count.index)}"
  volume_id   = "${element(aws_ebs_volume.default.*.id, count.index)}"
  instance_id = "${aws_instance.default.id}"
}