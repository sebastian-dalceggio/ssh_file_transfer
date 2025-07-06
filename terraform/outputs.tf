output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ssh_file_transfer_ec2.public_ip
}

output "private_key_file" {
  description = "The filename of the generated private key for SSH access"
  value       = local_file.ssh_file_transfer_private_key.filename
}

output "gc_storage_bucket_url" {
  value = google_storage_bucket.gc_cloud_storage.url
}