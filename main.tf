provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name_prefix = "redis_sg"
  vpc_id      = "${aws_vpc.my_vpc.id}"
  tags = {
    name = "redis-sg"
  }
  description = "redis sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_elasticache_cluster" "redis_db" {
#   cluster_id           = "cluster-example"
#   engine               = "redis"
#   node_type            = "cache.m4.large"
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis7"
#   engine_version       = "7.1"
#   port                 = 6379
#   tags = {
#     Name = "mynewcluster"
#   }
# }
resource "aws_elasticache_cluster" "redis_db" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  security_group_ids   = [aws_security_group.sg.id] # Associate the security group
  subnet_group_name    = aws_elasticache_subnet_group.subnet.name

  tags = {
    Name = "mynewcluster"
  }
}
# resource "aws_elasticache_cluster" "replica" {
#   cluster_id           = aws_elasticache_cluster.redis_db.id
#   replication_group_id = aws_elasticache_replication_group.redis_db.id
# }

# data "aws_outposts_outposts" "example" {}

# data "aws_outposts_outpost" "example" {
#   id = tolist(data.aws_outposts_outposts.replica.ids)[0]
# }

resource "aws_elasticache_subnet_group" "subnet" {
  name       = "my-cache-subnet"
  subnet_ids = [aws_subnet.private_tf.id,aws_subnet.private_tf1.id]

}
