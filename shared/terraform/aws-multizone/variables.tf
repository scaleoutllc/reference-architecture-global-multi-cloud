variable "name" {
  type = string
}

variable "parent_zone_id" {
  type = string
}

variable "parent_domain" {
  type = string
}

variable "providerRegions" {
  type = map(list(string))
}

