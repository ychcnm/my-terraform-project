variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "az" {
  description = "Availability zone"
  type        = string
  default     = "ap-southeast-1a"
}

variable "instance_ami" {
  description = "EC2 instance AMI"
  type        = string
  default     = "ami-04173560437081c75" # Amazon Linux 2023 AMI
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "Name of existing EC2 Key Pair"
  type        = string
}

variable "local_ip" {
  description = "Local IP address for SSH access"
  type        = string
  default     = "" # Leave empty to auto-detect
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {
    Project = "Terraform-VPC"
  }
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}