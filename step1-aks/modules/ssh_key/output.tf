output "public_key_openssh" {
  value = "${tls_private_key.ssh.public_key_openssh}"
}

output "public_key_pem" {
  value = "${tls_private_key.ssh.public_key_pem}"
}


output "private_key_pem" {
  value = "${tls_private_key.ssh.private_key_pem}"
}
