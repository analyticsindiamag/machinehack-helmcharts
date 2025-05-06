apiVersion: batch/v1
kind: Job
metadata:
  name: {{.Release.Name}}-exports-create-job-{{randAlpha 5 | lower}}
  namespace: "kloudlite"
  annotations:
    "helm.sh/hook": post-install, post-upgrade
    "helm.sh/hook-delete-policy": before-hook-creation, hook-succeeded
    "helm.sh/hook-weight": "10"
spec:
  template:
    spec:
      restartPolicy: Never
      serviceAccountName: kloudlite-cluster-admin
      containers:
        - name: post-job
          image: ghcr.io/kloudlite/hub/kubectl:latest
          command: ["bash", "-c"]
          args:
            - |+
              # Wait for init job to complete
              kubectl wait --for=condition=complete job/{{.Release.Name}}-cockroachdb-init -n {{.Release.Namespace}} --timeout=300s
              
              # Password is not stored in a secret by default since CockroachDB is configured to run in insecure mode
              # Use the configured password or default to empty string
              root_password="{{.Values.init.password}}"
              if [ -z "$root_password" ]; then
                # If no password is set, we're using insecure mode and the root user doesn't have a password
                root_password=""
              fi

              # Get nodePort for SQL and HTTP interfaces
              sql_port=$(kubectl get svc/{{.Release.Name}}-nodeport -n {{.Release.Namespace}} -o json | jq '.spec.ports[] | select (.name == "{{.Release.Name}}-sql") | .nodePort')
              http_port=$(kubectl get svc/{{.Release.Name}}-nodeport -n {{.Release.Namespace}} -o json | jq '.spec.ports[] | select (.name == "{{.Release.Name}}-http") | .nodePort')

              # Get external host or use the NodePort service IP if not set
              host="{{.Values.ingress.host}}"
              if [ -z "$host" ] || [ "$host" == "cockroachdb.example.com" ]; then
                # Fall back to the node IP
                NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
                if [ -z "$NODE_IP" ]; then
                  NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
                fi
                host="$NODE_IP"
              fi

              cat <<EOF | kubectl apply -f -
              apiVersion: v1
              kind: Secret
              metadata:
                name: {{.Release.Name}}-exports
                namespace: {{.Release.Namespace}}
              stringData:
                COCKROACHDB_USERNAME: "{{.Values.init.username}}"
                COCKROACHDB_PASSWORD: "$root_password"
                COCKROACHDB_HOST: "$host"
                COCKROACHDB_SQL_PORT: "$sql_port"
                COCKROACHDB_HTTP_PORT: "$http_port"
                COCKROACHDB_DATABASE: "{{index .Values.init.databases 0}}"
                COCKROACHDB_CONNECTION_STRING: "postgresql://{{.Values.init.username}}:$root_password@$host:$sql_port/{{index .Values.init.databases 0}}?sslmode=disable"
              EOF 