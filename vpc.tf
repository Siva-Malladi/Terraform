resource "aws_default_vpc" "my-vpc" {
    tags = {
        Name = "my-vpc"
    } 
}

resource "aws_subnet" "my-subnet-1" {
    vpc_id            = aws_default_vpc.my-vpc.id
    cidr_block        = "172.31.34.212/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true
    # This will automatically assign a public IP to instances launched in this subnet.
    tags = {
        Name = "my-subnet-1"
    
    }
}

resource "aws_subnet" "my-subnet-2" {
    vpc_id            = aws_default_vpc.my-vpc.id
    cidr_block        = "172.31.35.212/24"
    availability_zone = "eu-north-1b"  
    tags = {
        Name = "my-subnet-2"
    
    }
}
resource "aws_internet_gateway" "my-gateway" {
    vpc_id = aws_default_vpc.my-vpc.id
    tags = {
        Name = "my-gateway"
    }
}

resource "aws_route_table" "my-route-table" {
    vpc_id = aws_default_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-gateway.id
    }
    tags = {
        Name = "my-route-table"
    }
}

resource "aws_route_table_association" "my-route-table-assoc-1" {
    subnet_id      = aws_subnet.my-subnet-1.id
    route_table_id = aws_route_table.my-route-table.id
}

