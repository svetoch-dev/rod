output "ci" {
  description = "CI vars"
  value       = module.ci.ci_vars
  sensitive   = true
}
