# Task 1 — Networking & Subnetting (VPC)

**Brief approach (4–6 lines)**:
- Create a single VPC with a /16 CIDR.
- Create 2 public and 2 private subnets across two AZs for basic HA.
- Attach an Internet Gateway and create public route table.
- Create NAT Gateway in a public subnet with Elastic IP to allow private subnets outbound internet access.

**CIDR choices (example)**:
- VPC: 10.10.0.0/16
- Public Subnet A (AZ1): 10.10.1.0/24
- Public Subnet B (AZ2): 10.10.2.0/24
- Private Subnet A (AZ1): 10.10.101.0/24
- Private Subnet B (AZ2): 10.10.102.0/24

**How to run**:
1. `terraform init`
2. `terraform apply -var 'prefix=FirstName_Lastname' -auto-approve`
3. After verification, `terraform destroy -var 'prefix=FirstName_Lastname' -auto-approve`

Replace `FirstName_Lastname` with your name prefix as requested.

Screenshots to capture after apply:
- VPC page
- Subnets list
- Route tables (public routes)
- NAT Gateway + IGW

