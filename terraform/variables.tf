variable "aws_region" {
  description = "AWS region for resource deployment"
  default     = "us-east-1"
}

variable "key_name" {
  description = "AWS EC2 Key Pair Name"
  type        = string
  default     = "devsecops_aws_key"
}
