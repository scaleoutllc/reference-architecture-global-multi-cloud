variable "name" {
  type = string
}

variable "deployments" {
  type = list(map(string))
}

variable "parent_zone_id" {
  type = string
}

variable "parent_domain" {
  type = string
}

