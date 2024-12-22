## MiniKube

### Task

- Create pod with nginx in your local cluster

- Create service for nginx which will expose port 80 of nginx to your local network

- Check that you can see nginx default web page on your PC

### HOW TO

Start minikube

```shell
minikube start
```

or

```shell
minikube start --driver=docker
```

Verify the cluster is running:

```shell
kubectl cluster-info
```

Apply configs

```shell
kubectl apply -f src/
```

Get minikube service list

```shell
minikube service list
```

Get all services

```shell
kubectl get services
```

Get pods

```shell
kubectl get pods
```

Get minikube IP

```shell
minikube ip
```

Describe nginx-service

```shell
kubectl describe services nginx-service
```

Use the minikube service command to open the service in your default browser

```shell
minikube service nginx-service
```

or find the URL for the Service: Use Minikube's service command to get the Service's URL

```shell
minikube service nginx-service --url
```

Or we can use port forwarding

Confirm the port of your pod

```shell
kubectl get pod nginx-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}' -n default
```

For example, you will have 80 in response

```shell
80
```

And then 8080 - local port, 80 - pod port

```shell
kubectl port-forward nginx-pod 8080:80 -n default
```

Check Pod Logs: If the Pod isn't running, check the logs for more information

```shell
kubectl logs nginx-pod
```

Remove deployment

```shell
kubectl delete -f src/
```

Stop minikube

```shell
minikube stop
```
