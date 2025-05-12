apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{.Release.Name}}
  ports:
    - port: 7474
      targetPort: 7474
      name: http
    - port: 7687
      targetPort: 7687
      name: bolt
  type: ClusterIP
