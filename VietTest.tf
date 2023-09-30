provider "aws" {
    region = "us-east-1"
}

# Define an external data source for retrieving sensitive credentials securely.
data "external" "secrets" {
    program = ["bash", "${path.module}/get_secrets.sh"]
}

# Define a security group for the EC2 instance.
resource "aws_security_group" "example" {
    name        = "example-security-group"
    description = "Security group for the example EC2 instance"

    # Allow SSH access from a trusted IP address.
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${data.external.secrets.result["trusted_ip"]}/32"]
    }

    # Example: Open a port for a web server, which could be a potential security risk.
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Example: Open a database port (e.g., MySQL), which could also be a security risk if not properly secured.
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Define an AWS EC2 instance.
resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    # Associate the security group created above.
    vpc_security_group_ids = [aws_security_group.example.id]

    # Use a public key for SSH access.
    key_name = "your-ssh-key-name"

    # Example: Intentionally store sensitive data in user data, which is a security risk.
    user_data = <<-EOF
        #!/bin/bash
        echo "This is sensitive data stored in user data."
        EOF

    # Tags for the EC2 instance.
    tags = {
        Name = "example-instance"
    }
}
