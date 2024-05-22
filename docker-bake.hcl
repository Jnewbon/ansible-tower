group "default" {
  targets = ["manager"]
}

target "manager" {
  inherits = ["docker-metadata-action-manager"]
  dockerfile = "Dockerfile"
  target = "ansible-tower"
}

# Targets to allow injecting customizations from Github Actions.

target "docker-metadata-action-manager" {}
