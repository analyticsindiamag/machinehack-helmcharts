apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-neo4j
  namespace: {{ .Release.Namespace }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Release.Name }}-neo4j
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-neo4j
    spec:
      containers:
        - name: neo4j
          image: neo4j:5.15.0  # or latest stable
          env:
            - name: NEO4J_AUTH
              value: neo4j/Strongpassword@123  
            - name: NEO4J_server_config_strict__validation_enabled
              value: "false"
          ports:
            - containerPort: 7474  # HTTP
            - containerPort: 7687  # Bolt
          volumeMounts:
            - name: data
              mountPath: /data
            - name: logs
              mountPath: /logs
            - name: plugins
              mountPath: /plugins
      volumes:
        - name: data
          emptyDir: {}
        - name: logs
          emptyDir: {}
        - name: plugins
          emptyDir: {}
