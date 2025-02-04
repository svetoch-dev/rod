output "repos" {
  description = "github repositories"
  value       = module.github.repositories
  sensitive   = true
}
