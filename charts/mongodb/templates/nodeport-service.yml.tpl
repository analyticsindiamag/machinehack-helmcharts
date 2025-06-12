apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name}}-nodeport
  namespace: {{.Release.Namespace}}
spec:
  type: NodePort
  ports:
  - name: {{.Release.Name}}
    port: 27017
    protocol: TCP
    targetPort: {{.Release.Name}}
    {{- if .Values.mongodb.service.nodePort }}
    nodePort: {{.Values.mongodb.service.nodePort}}
    {{- end }}
  selector:
    app.kubernetes.io/component: {{.Release.Name}}
    app.kubernetes.io/instance: {{.Release.Name}}
    app.kubernetes.io/name: {{.Release.Name}}

