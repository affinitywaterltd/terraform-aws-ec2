output "private_ip" {
  description = "Private IP of instance"
  value       = "${aws_instance.default.private_ip}"
}

output "ec2_id" {
  description = "Disambiguated ID of the instance"
  value       = "${aws_instance.default.id}"
}

