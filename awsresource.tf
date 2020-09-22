provider "aws" {
  region     = "ap-southeast-2"
  access_key = "AKIA5IAJ5VPBGHLJFEBL"
  secret_key = "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"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "san-wandemo-VPC01"
  }
}
resource "aws_subnet" "demo" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "demosubnet"
  }
}
resource "aws_vpn_gateway" "vpngw" {
  tags = {
    Name = "san-wandemo"
  }
}
resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = aws_vpc.vpc.id
  vpn_gateway_id = aws_vpn_gateway.vpngw.id
}