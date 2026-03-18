environment      = "production"
instance_type    = "t2.medium" # Or t3.medium for prod
desired_capacity = 3
min_size         = 2
max_size         = 10
vpc_cidr         = "10.1.0.0/16"