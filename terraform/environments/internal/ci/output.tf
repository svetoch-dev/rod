output "ci" {
  description = "CI configs"
  value       = module.ci.cis
  sensitive   = true
}
