variable "rds_instances" {
  type = map(object({
    db_name = string
  }))

  default = {
    mysql-db-1 = {
      db_name = "lambdadb1"
    }

    mysql-db-2 = {
      db_name = "database2"
    }
  }
}

#ec2
variable "public_sg_rules" {
  type = object({

    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))

    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
}
variable "private_sg_rules" {
  type = object({
    ingress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
    }))

    egress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
    }))
  })
}

variable "env" {
  type = string
}

variable "alb_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "alb_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}
variable "lambda_egress_rules" {

  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

}
variable "db_instance_class" {
  type = string
}

variable "db_storage" {
  type = number
}
variable "s3_buckets" {
  type = map(string)

  default = {
    sonubucket = "sonu-motki-application-bucket"
    jitubucket = "jitu-motki-application-bucket"
  }
}
variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {}

variable "private_subnets" {}

variable "db_secret_arn" {
  type = string
}


