This project is showcasing end-to-end infrastructure automation and security best practices. Here are the major highlights :

GitOps Workflow Implementation: 
Set up a full CI/CD pipeline using GitHub Actions (13:58) to automate the entire lifecycle of AWS infrastructure,
moving away from manual provisioning.

Infrastructure as Code (IaC): 
Utilized Terraform to provision a secure and scalable two-tier AWS architecture (1:57) including VPCs, private subnets, and an Application Load Balancer.

Advanced Security Scanning: 
Integrated Trivy directly into the pipeline for vulnerability scanning (14:10, 38:29) to detect and remediate security risks before deployment,
such as open SSH ports or unsecured load balancers (41:20).

Production-Ready Pipeline Security: 
Implemented required manual approvals for production deployments and established Terraform Workspaces to manage environment-specific configurations (Dev, Test, Prod) via tfvars files.

Infrastructure Destruction Automation: 
Created a automated workflow to properly destroy resources (43:00) to ensure cost efficiency when the infrastructure is no longer needed.
