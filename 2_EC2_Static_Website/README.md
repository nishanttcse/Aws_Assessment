# Task 2 — EC2 Static Website (Nginx)

**Brief approach (4–6 lines)**:
- Create a t2.micro EC2 instance in a public subnet with a security group allowing HTTP (80) and SSH (22) from your IP.
- Use `user_data` to install Nginx and deploy an `index.html` containing your resume content.
- Follow basic hardening: disable password auth, restrict SSH via security group to your IP, keep minimal open ports, and use IAM roles if needed.

**How to run**:
1. Ensure the VPC and public subnet from Task 1 exist or reuse the Terraform VPC module.
2. `terraform init && terraform apply -var 'prefix=FirstName_Lastname' -auto-approve`
3. Visit the EC2 public IP on port 80 to view the static resume.
4. Destroy with `terraform destroy`.

