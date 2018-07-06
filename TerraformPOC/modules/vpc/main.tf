
resource "aws_internet_gateway" "ggkIGW" {
  vpc_id = "${aws_vpc.ggktf.id}"

  tags {
	Name = "ggkIGW"
  }
}

resource "aws_vpc" "ggktf"
{
 cidr_block = "192.168.10.0/24"
 tags
 {
  Name = "ggk_vpc"
 }
}

resource "aws_subnet" "ggksubnet1" {
  vpc_id 	= "${aws_vpc.ggktf.id}"
  cidr_block = "192.168.10.0/25"

  tags {
	Name = "ggksubnet1"
  }
}



resource "aws_route_table" "ggk_route_table"{
 vpc_id = "${aws_vpc.ggktf.id}"
 
 route{
  gateway_id = "${aws_internet_gateway.ggkIGW.id}"
  cidr_block = "0.0.0.0/0"
 }

 tags{
  Name = "ggk_route_table"
 }

}

resource "aws_route_table_association" "ggk_rt_assoc"
{
 subnet_id = "${aws_subnet.ggksubnet1.id}"
 route_table_id = "${aws_route_table.ggk_route_table.id}"
}

resource "aws_security_group" "all_traffic"{
 name = "TF_security_group"
 description = "this is created with the help of terraform"
 vpc_id = "${aws_vpc.ggktf.id}"
 ingress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "TF_instance"
{
 ami="ami-2cf54551"
 instance_type="t2.micro"
 key_name="Chandu"
 tags{
  Name="TFinstance"
 }
 subnet_id = "${aws_subnet.ggksubnet1.id}"
 associate_public_ip_address = true
 vpc_security_group_ids = ["${aws_security_group.all_traffic.id}"]

user_data = <<-EOF
     #!/bin/bash
     sudo yum update
     sudo yum install -y tomcat
     mkdir /home/ec2-user/hello
    EOF

}
output "ip"{
value = "${aws_instance.TF_instance.public_ip}"
}
