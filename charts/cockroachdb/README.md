# CockroachDB Helm Chart

This Helm chart deploys [CockroachDB](https://www.cockroachlabs.com/) - a cloud-native, distributed SQL database that provides strong consistency, high availability, and horizontal scalability.

## Features

- Deploys a scalable CockroachDB cluster
- Configurable resources
- Persistent storage
- Ingress for web UI access
- Service for SQL access
- Export of connection details via Kubernetes Secret
- Dynamic hostname generation based on environment name

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure
- LoadBalancer or Ingress controller (for external access)

## Chart Structure

The chart follows a standardized structure similar to the nginx Helm chart:

```
cockroachdb/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default configuration values
├── templates/
│   ├── deployment.yaml     # StatefulSet for CockroachDB pods
│   ├── service.yaml        # Services for inter-node and client access
│   ├── ingress.yaml        # Web UI ingress configuration
│   ├── exports.yaml        # Exports secrets with connection details
│   ├── configmap.yaml      # CockroachDB configuration
│   ├── init-job.yaml       # Initialization job for database setup
│   └── NOTES.txt           # Usage notes displayed after installation
└── README.md               # Documentation
```

## Installing the Chart

```bash
# Create namespace
kubectl create namespace cockroachdb

# Install the chart
helm install cockroachdb ./charts/cockroachdb -n cockroachdb
```

## Configuration

The following table lists the configurable parameters for the CockroachDB chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of CockroachDB nodes | `3` |
| `image.repository` | CockroachDB image repository | `cockroachdb/cockroach` |
| `image.tag` | CockroachDB image tag | `v23.1.11` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `ingress.enabled` | Enable ingress for the web UI | `true` |
| `ingress.host` | Hostname for the ingress | `cockroachdb-{env_name}.machinehack-new.clients.kloudlite.io` |
| `ingress.className` | Ingress class name | `nginx` |
| `resources.requests.cpu` | CPU request | `500m` |
| `resources.requests.memory` | Memory request | `1Gi` |
| `resources.limits.cpu` | CPU limit | `2` |
| `resources.limits.memory` | Memory limit | `4Gi` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.size` | Size of persistent volume | `100Gi` |
| `persistence.storageClass` | Storage class for PVCs | `standard` |
| `init.databases` | Initial databases to create | `["defaultdb"]` |
| `init.username` | Admin username | `root` |
| `init.password` | Admin password (leave empty for auto-generated) | `""` |

## Accessing CockroachDB

After the chart is deployed, you can access CockroachDB in several ways:

1. **Web UI**: Access via the ingress hostname that's generated based on your environment name
   
   For example: `https://cockroachdb-myenv.machinehack-new.clients.kloudlite.io`
   
   The `{env_name}` placeholder in the ingress host will be automatically replaced with your actual environment name.

2. **SQL Client**: Connect using the PostgreSQL-compatible SQL interface:

   ```bash
   # Get the exported connection details
   kubectl get secret cockroachdb-exports -n cockroachdb -o yaml
   
   # Use with any PostgreSQL client
   psql "postgresql://root:<password>@<host>:<port>/defaultdb?sslmode=disable"
   ```

3. **CockroachDB SQL Shell**:

   ```bash
   kubectl exec -it cockroachdb-cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure
   ```

## Security Considerations

By default, this chart deploys CockroachDB in insecure mode for simplicity. For production deployments, you should enable TLS encryption and authentication. 