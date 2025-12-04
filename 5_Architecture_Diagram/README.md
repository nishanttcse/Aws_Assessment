# Task 5 — Architecture Diagram

**Brief explanation (5–8 lines)**:
Design targets 10,000 concurrent users:
- Internet-facing ALB terminates TLS and distributes traffic to an Auto Scaling group of web servers in private subnets across multiple AZs.
- Auto Scaling group scales based on request metrics (ALB request count / target CPU).
- Web tier communicates with a managed RDS/Aurora cluster in private subnets; read replicas for scaling reads.
- ElastiCache (Redis) is used for session caching, rate-limiting, and fast lookups.
- Security Groups and NACLs control ingress/egress; WAF is placed in front of ALB for protection.
- Observability via CloudWatch (metrics, logs), X-Ray for tracing, and centralised S3 for logs/CFN templates.

You will find `architecture.png` in this folder — you can include it in your submission or import it into draw.io as a background reference.

