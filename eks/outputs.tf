########################################
# EKS Cluster outputs
########################################

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint для доступу до Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "CA data для kubeconfig"
  value       = module.eks.cluster_certificate_authority_data
}

########################################
# Node groups
########################################

output "eks_managed_node_groups" {
  description = "Map з усіма eks-managed node groups"
  value       = module.eks.eks_managed_node_groups
}

output "node_security_group_id" {
  description = "Security Group, створений для нод"
  value       = module.eks.node_security_group_id
}

output "node_security_group_arn" {
  description = "ARN security group для нод"
  value       = module.eks.node_security_group_arn
}

########################################
# Networking
########################################

output "cluster_primary_security_group_id" {
  description = "Primary security group ID для EKS кластера"
  value       = module.eks.cluster_primary_security_group_id
}

# Якщо треба ще й ARN Primary SG
data "aws_security_group" "cluster_primary" {
  id = module.eks.cluster_primary_security_group_id
}

output "cluster_primary_security_group_arn" {
  description = "Primary security group ARN"
  value       = data.aws_security_group.cluster_primary.arn
}

# ./eks/outputs.tf  (додайте в кінець)

# Ім'я кластера (є в модулі EKS v20+)
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

# ARN OIDC-провайдера (з'являється, якщо enable_irsa = true)
output "oidc_provider_arn" {
  description = "OIDC provider ARN (IRSA)"
  value       = module.eks.oidc_provider_arn
}

