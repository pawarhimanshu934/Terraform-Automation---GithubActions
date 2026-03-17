variable "region" {
    description = "The AWS region to deploy resources in"
    default     = "us-east-1"
}

variable "environment" {
    description = "The environment to deploy resources in"
    default     = "dev"
}

variable "vpc_cidr" {
    description = "value for vpc cidr block"
    default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
    description = "number of public subnets to create"
    default     = 2  
}

variable "private_subnet_count" {
  description = "Number of private subnet to create"
  type = number
  default = 2
}

variable "public_subnet_cidr" {
    description = "List of CIDR block for public subnet"
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
} 

variable "private_subnet_cidr" {
    description = "List of CIDR block for priavte subnet"
    type = list(string)
    default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "availability_zone" {
    description = "availability zone for subnets"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ]
  
}

variable "instance_type" {
  description = "Instance type of launch template"
  type = string
  default = "t2.micro"
}

variable "image_id" {
    description = "Image ID of launch template"
    type = string
    default = "ami-0b6c6ebed2801a5cb"
}

variable "desired_capacity"{
   description = "Desired capacity of ASG"
   type = number
   default = 2
}

variable "max_size" {
    description = "Max size of ASG"
    type = number
    default = 4
}

variable "min_size" {
    description = "Min size of ASG"
    type = number
    default = 1
}
