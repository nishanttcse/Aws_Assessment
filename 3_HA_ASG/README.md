# Task 3 — High Availability + Auto Scaling (ALB + ASG)

**Brief approach (4–6 lines)**:
- Create a launch template that uses the same Nginx user-data to boot instances in private subnets.
- Create an Internet-facing ALB in public subnets with a target group that points to instances on port 80.
- Create an Auto Scaling Group spanning the two private subnets across AZs to launch instances for the target group.
- ALB handles incoming public traffic -> routes to instances in private subnets. NAT/IGW allow instances to access internet for package updates.

**How to run**:
1. `terraform init && terraform apply -var 'prefix=FirstName_Lastname' -auto-approve`
2. Capture screenshots of ALB, target group, ASG, and EC2 instances.
3. `terraform destroy`

Notes: Replace placeholder values and ensure subnets/roles exist.
