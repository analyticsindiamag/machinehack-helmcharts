# VSCode Web Helm Chart

This Helm chart deploys VSCode (code-server) in your Kubernetes cluster, allowing you to access VSCode through your web browser from anywhere.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installation

1. Clone this repository or copy the chart files
2. Install the chart with a release name (e.g., `my-vscode`):

```bash
helm install my-vscode ./vscode-web --set config.password=your-secure-password
```

## Configuration

The following table lists the configurable parameters of the VSCode chart and their default values:

| Parameter                | Description             | Default        |
|-------------------------|-------------------------|----------------|
| `image.repository`      | Image repository        | `codercom/code-server` |
| `image.tag`            | Image tag               | `4.19.1`       |
| `image.pullPolicy`     | Image pull policy       | `IfNotPresent` |
| `service.type`         | Service type            | `LoadBalancer` |
| `service.port`         | Service port            | `8080`         |
| `persistence.enabled`  | Enable persistence      | `true`         |
| `persistence.size`     | Storage size            | `10Gi`         |
| `config.password`      | VSCode web UI password  | `""`           |
| `resources.limits`     | Pod resource limits     | `{cpu: 1000m, memory: 2Gi}` |
| `resources.requests`   | Pod resource requests   | `{cpu: 500m, memory: 1Gi}`  |

## Usage

1. After installation, get the external IP address:
```bash
kubectl get svc my-vscode-vscode-web
```

2. Access VSCode in your browser:
```
http://<EXTERNAL-IP>:8080
```

3. Log in using the password you set during installation.

## Persistence

The chart mounts a Persistent Volume at `/home/coder`. This is where all your workspace files and VSCode configurations will be stored.

## Uninstallation

To uninstall/delete the `my-vscode` deployment:

```bash
helm uninstall my-vscode
```

Note: This will not delete the PersistentVolumeClaim. To delete it:

```bash
kubectl delete pvc <pvc-name>
``` 