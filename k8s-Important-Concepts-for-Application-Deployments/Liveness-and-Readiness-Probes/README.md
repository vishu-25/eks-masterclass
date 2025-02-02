# Kubernetes - Liveness & Readiness Probes

## Step-01: Introduction

In Kubernetes, **probes** are mechanisms that allow the system to check the health and readiness of a container. There are three types of probes:

1. **Liveness Probe**: Determines if a container is still running. If a liveness probe fails, Kubernetes kills the container and restarts it based on the restart policy.
2. **Readiness Probe**: Determines if a container is ready to accept traffic. If a readiness probe fails, Kubernetes removes the container from service endpoints until it becomes healthy again.
3. **Startup Probe**: Used for applications that take a long time to start. It prevents Kubernetes from killing the container before it's fully initialized.

Each of these probes can be implemented in three different ways:
- **Exec Probe**: Runs a command inside the container.
- **HTTP Probe**: Sends an HTTP request to a specified endpoint.
- **TCP Probe**: Checks if a TCP socket is open on a given port.

---

## Step-02: Create Liveness Probe with Command
The following `livenessProbe` configuration uses an **Exec Probe** to check if port `8095` is open inside the container.

```yaml
livenessProbe:
  exec:
    command:
      - /bin/sh
      - -c
      - nc -z localhost 8095
  initialDelaySeconds: 60
  periodSeconds: 10
```
- **`initialDelaySeconds`**: The probe waits for 60 seconds before starting health checks.
- **`periodSeconds`**: The probe runs every 10 seconds.
- **`nc -z localhost 8095`**: Uses netcat (`nc`) to check if port `8095` is open.

---

## Step-03: Create Readiness Probe with HTTP GET
The following `readinessProbe` configuration uses an **HTTP Probe** to check if the application is ready to accept traffic.

```yaml
readinessProbe:
  httpGet:
    path: /usermgmt/health-status
    port: 8095
  initialDelaySeconds: 60
  periodSeconds: 10     
```
- **`httpGet.path`**: Defines the endpoint (`/usermgmt/health-status`) that Kubernetes checks.
- **`port`**: Specifies the container port (`8095`).
- **`initialDelaySeconds`**: Waits 60 seconds before starting health checks.
- **`periodSeconds`**: Runs every 10 seconds.

---

## Step-04: Create Kubernetes Objects & Test

### Deploy the Application
```sh
# Create All Objects
kubectl apply -f kube-manifests/
```

### Check Pod Status
```sh
# List Pods
kubectl get pods

# Watch Pods in real-time
kubectl get pods -w
```

### Inspect the Pod
```sh
# Describe the pod to check probe status
kubectl describe pod <usermgmt-microservice-xxxxxx>
```

### Test Application Health
```sh
# Access the application health status page
http://<WorkerNode-Public-IP>:31231/usermgmt/health-status
```

**Observation:**
- The User Management Microservice pod will **not** be in the `READY` state to accept traffic until it completes the `initialDelaySeconds=60` seconds of the readiness probe.
- If the liveness probe fails, Kubernetes will restart the container.

---

## Step-05: Clean-Up
To delete all created Kubernetes objects:

```sh
# Delete all objects
kubectl delete -f kube-manifests/

# Verify cleanup
kubectl get pods
kubectl get sc,pvc,pv
```

---

## References:
- Kubernetes Probes: [Official Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

