# terraform/variables.tf

variable "aws_region" {
  description = "AWS Region එක"
  default     = "us-east-1"
}

variable "devsecops_aws_key" {
  description = "devsecops-aws-key"
  type        = string
}
