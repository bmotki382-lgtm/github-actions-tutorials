env = "dev"

alb_ingress_rules = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

alb_egress_rules = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]

ami_id        = "ami-01a00762f46d584a1"
instance_type = "t3.micro"
key_name      = "Linux"

lambda_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
db_instance_class = "db.t3.micro"
db_storage        = 20

region  = "ap-south-1"
vpc_cidr = "10.0.0.0/16"

public_subnets = {
  public-1 = {
    cidr = "10.0.1.0/24"
    az   = "ap-south-1a"
  }

  public-2 = {
    cidr = "10.0.2.0/24"
    az   = "ap-south-1b"
  }

  public-3 = {
    cidr = "10.0.3.0/24"
    az   = "ap-south-1c"
  }
}

private_subnets = {
  private-1 = {
    cidr = "10.0.4.0/24"
    az   = "ap-south-1a"
  }

  private-2 = {
    cidr = "10.0.5.0/24"
    az   = "ap-south-1b"
  }

  private-3 = {
    cidr = "10.0.6.0/24"
    az   = "ap-south-1c"
  }
}
db_secret_arn = "arn:aws:secretsmanager:ap-south-1:151170150914:secret:dbseceret-5TyDsr"

public_sg_rules = {

  ingress = [

    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [

    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

private_sg_rules = {

  ingress = [

    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["10.0.0.0/16"]
      security_groups = []
    }

  ]

  egress = [

    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }

  ]
}