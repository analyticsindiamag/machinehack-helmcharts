apiVersion: v1
kind: Service
metadata:
  name: {{ include "code-server.name" . }}
  namespace: {{.Release.Namespace}}
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
      name: http
  selector:
    app: {{ include "code-server.name" . }} 