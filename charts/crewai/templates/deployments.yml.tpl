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
      - name: crewai
        image: "{{ .Values.codeServer.image.repository }}:{{ .Values.codeServer.image.tag }}"
        ports:
        - containerPort: 8000