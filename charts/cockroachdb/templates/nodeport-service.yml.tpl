apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}-nodeport
  namespace: {{.Release.Namespace}}
spec:
  type: NodePort
  ports:
  - name: {{.Release.Name}}-sql
    port: 26257
    protocol: TCP
    targetPort: 26257
  - name: {{.Release.Name}}-http
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: cockroachdb
    release: {{.Release.Name}} 