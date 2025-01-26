provider "aws" {
  region = "us-east-2"
}


resource "aws_s3_bucket" "churn_flask" {
  bucket = "churn-model-8734653052" 

  tags = {
    Name        = "churn bucket"
    Environment = "Churn-Model"
  }
  

  provisioner "local-exec" {
    command = "${path.module}/upload_to_s3.sh"
  }
  
  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://churn-model-8734653052 --recursive"
  }
}


resource "aws_instance" "foo" {

  ami = "ami-08970251d20e940b0"  

  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.profile_iam_access.name

  vpc_security_group_ids = [aws_security_group.churn_model_api_sg.id]

  
  user_data = <<-EOF
                
                sudo yum update -y
                sudo yum install -y python3 python3-pip awscli
                sudo pip3 install flask joblib scikit-learn numpy scipy pandas joblib os gunicorn
                sudo mkdir /model_training
                sudo aws s3 sync s3://churn-model-8734653052 /model_training
                cd /model_training
                nohup gunicorn -w 4 -b 0.0.0.0:5000 app:app &
              EOF


  tags = {
    Name = "ChurnModelFlaskApp"
  }
}

resource "aws_security_group" "churn_model_api_sg" {
  
  name        = "chrun_model_api_sg"
  
  description = "Security Group for Flask App in EC2"

  
  ingress {
    description = "Inbound Rule 1"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    description = "Inbound Rule 2"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    description = "Inbound Rule 3"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound Rule"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "access_role" {
  
  name = "access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_access_policy" {
  
  name = "s3_access_policy"
  
  role = aws_iam_role.access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.churn_flask.arn}/*",
          "${aws_s3_bucket.churn_flask.arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "profile_iam_access" {
  name = "profile_iam_access"
  role = aws_iam_role.access_role.name
}


