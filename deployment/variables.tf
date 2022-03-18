variable "prefix" {
  type        = string
  description = "A string representing the prefix you would like to add to all of your infrastructure"
}

variable "project" {
  type        = string
  description = "A string representing the name of the project"
  default     = "football-organiser"
}
