INSTRUCTIONS to use this repo
----------------------------
1. Edit Terraform variable values in each folder (especially `prefix` and subnet ids).
2. For Task1, run terraform in 1_VPC to create VPC resources (this will create EIP for NAT which can cost small amounts).
3. For Task2, either reference public_subnet_id from Task1 outputs or use an existing public subnet.
4. For Task3, provide lists of public_subnet_ids and private_subnet_ids (from Task1 outputs).
5. For Task4, note CloudWatch billing metrics require region us-east-1.
6. Always `terraform destroy` after capturing screenshots to avoid costs.
