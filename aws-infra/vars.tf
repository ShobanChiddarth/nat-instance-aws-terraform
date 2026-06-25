variable "region" {
    type = string
    description = "aws region"
    default = "ap-south-1"
}

variable "my_public_ip" {
    type = string
    description = "my public ip"
    default = "0.0.0.0/0"
}
