apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}
  namespace: {{.Release.Namespace}}
spec:
  selector:
    app: {{.Release.Name}}
  ports:
    - protocol: TCP
      port: 5678
      targetPort: 5678
  type: ClusterIP
