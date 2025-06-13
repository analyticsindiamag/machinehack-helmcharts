apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{.Release.Name}}
  template:
    metadata:
      labels:
        app: {{.Release.Name}}
    spec:
      containers:
      - name: n8n
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        command:
        - "sh"
        - "-c"
        - |
          # Wait for any potential database to be ready
          sleep 10
          # Start n8n in the background
          /usr/local/bin/n8n start &
          # Wait for n8n to be ready
          until curl -s http://localhost:5678/healthz > /dev/null; do
            echo "Waiting for n8n to be ready..."
            sleep 5
          done
          # Create admin user if not exists
          /usr/local/bin/n8n user:create --email admin@machinehack.com --password '$13423@' --first-name Admin --last-name User --role owner || true
          # Keep the container running
          tail -f /dev/null
        ports:
          - containerPort: 5678
        readinessProbe:
          httpGet:
            path: /healthz
            port: 5678
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        env:
          {{- range .Values.env }}
          - name: {{ .name }}
            value: "{{ .value }}"
          {{- end }}