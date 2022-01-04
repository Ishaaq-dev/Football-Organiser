variable "s3_bucket_names" {
  type = set(string)
  default = [
    "dev",
    "personal"
  ]
}

variable "project" {
  type        = string
  description = "A string representing the name of the project"
  default     = "football-organiser"
}
