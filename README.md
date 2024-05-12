# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

# How deployment process work and how the user can deploy change
- User must store application source code on github. When any user push new source code on `main` branch. It will be trigger AWS Code Pipeline.
AWS Code Pipeline has 3 phase: 
    - Prebuid: Authentication
    - Build: Build image from new source code on `main` branch
    - Postbuild: push new image ECR

- Your application is hosted on node, which is managed by cluster of EKS => After aws code pipeline process finished, you can update cluster by run "new" image in ECR
- You can tracking your application by Cloudwatch Insight

### Stand Out Suggestions
Please provide up to 3 sentences for each suggestion. Additional content in your submission from the standout suggestions do _not_ impact the length of your total submission.
1. Specify reasonable Memory and CPU allocation in the Kubernetes deployment configuration
-> With my opinion, we need at least 512mb of memory and 1 CPU cores for each container (with this scenario). It can be modified based on the expected workload of the analytics API
2. In your README, specify what AWS instance type would be best used for the application? Why?
-> t3.medium. Because its price is cheap and provides relatively good work performance with simple workloads
3. In your README, provide your thoughts on how we can save on costs?
-> 
- Use spot instances for non-prod environment
- Implement ASG with min, and max instances on-demand
- Use cloudwatch and metrics to tracking the activity of system to offer a cost-eficiency suitable for business workload