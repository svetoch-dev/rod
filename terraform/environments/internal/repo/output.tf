output "repos" {
  description = "Repositories"
  value       = module.repos.repo
  sensitive   = true
}
