### Step Kubernetes

1. Creating a simple application
    - Use Python programming language to create a simple web application with MySQL database
    - Create a Dockerfile to build a container image of your application[^1].

2. Setting up a Kubernetes Cluster
    - ~~MiniKube:~~[^2]
        - ~~Install MiniKube on your local machine to create a single-node Kubernetes cluster.~~
        - ~~Start the cluster using minikube start.~~
    - Kubernetes Configuration Files:
        - Create YAML files to define your application's deployment, service, and other resources.

3. Deploying the Application
    - Use kubectl to apply your YAML files to the Kubernetes cluster.
    - Check the status of your deployment and service using kubectl get pods and kubectl get services.

4. Integrating with GitLab
    - Configure GitLab CI/CD to automatically build, test, and deploy your application to Kubernetes.
    - Create a GitLab CI/CD pipeline using a .gitlab-ci.yml file.

5. Persistent Volumes
    - Create a persistent volume claim (PVC) to request storage for your application.
    - Create a persistent volume (PV) to provision storage for the PVC.
    - Mount the PV to your application's pod.

[^1]: Note: you can reuse the same application from module 8.
[^2]: було прийнято рішення не використовувати minikube
