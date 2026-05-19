1. Deploy AWS infrastructure:
   cd infra
   terraform init
   terraform apply

2. Build and push Docker images through Jenkins:
   Run the Jenkins pipeline job from GitHub.

3. Open the ALB DNS output from Terraform:
   Visit the public frontend URL in the browser.

4. Verify the frontend loads SUCCESS and calls the backend endpoint.