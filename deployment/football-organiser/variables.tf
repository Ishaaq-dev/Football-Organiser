variable "environment" {
  type        = string
  description = "A string representing the environment you would like to deploy in"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "A string representing the name of the project"
  default     = "football-organiser"
}
