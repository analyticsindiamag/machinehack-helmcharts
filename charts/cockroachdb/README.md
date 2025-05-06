# CockroachDB Helm Chart

This Helm chart deploys [CockroachDB](https://www.cockroachlabs.com/) - a cloud-native, distributed SQL database that provides strong consistency, high availability, and horizontal scalability.

## Features

- Deploys a scalable CockroachDB cluster
- Configurable resources
- Persistent storage
- Ingress for web UI access
- NodePort service for SQL access
- Export of connection details via Kubernetes Secret

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure
- LoadBalancer or Ingress controller (for external access)

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
| `ingress.host` | Hostname for the ingress | `cockroachdb.example.com` |
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

1. **Web UI**: Access via the ingress hostname at `https://cockroachdb.example.com`

2. **SQL Client**: Connect using the PostgreSQL-compatible SQL interface:

   ```bash
   # Get the exported connection details
   kubectl get secret cockroachdb-exports -n cockroachdb -o jsonpath="{.data.COCKROACHDB_CONNECTION_STRING}" | base64 -d
   
   # Use with any PostgreSQL client
   psql "postgresql://root:<password>@<host>:<port>/defaultdb?sslmode=disable"
   ```

3. **CockroachDB SQL Shell**:

   ```bash
   kubectl exec -it cockroachdb-cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure
   ```

## Security Considerations

By default, this chart deploys CockroachDB in insecure mode for simplicity. For production deployments, you should enable TLS encryption and authentication. 