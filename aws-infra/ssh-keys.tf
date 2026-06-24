resource "tls_private_key" "bastion_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name = "bastion_key_pair"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_file" "bastion_priv_key_local_file" {
  filename = "${path.module}/.ssh/${aws_key_pair.bastion_key_pair.key_name}.pem"
  content = tls_private_key.bastion_key.private_key_openssh
  file_permission = 0600
}
