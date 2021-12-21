variable "environment" {
  type        = string
  description = "A string representing the environment you would like to deploy in"
  default     = "development"
}

variable "project" {
  type        = string
  description = "A string representing the name of the project"
}
