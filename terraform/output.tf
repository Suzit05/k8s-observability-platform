output "control_node_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_node_ip" {
  value = aws_instance.worker_node[*].public_ip
}