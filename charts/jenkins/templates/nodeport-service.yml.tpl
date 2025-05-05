apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-nodeport
  namespace: {{ .Release.Namespace }}
spec:
  type: NodePort
  ports:
    - name: jenkins
      port: 8080
      protocol: TCP
      targetPort: 8080
  selector:
    app.kubernetes.io/component: jenkins-controller
    app.kubernetes.io/instance: {{ .Release.Name }}
