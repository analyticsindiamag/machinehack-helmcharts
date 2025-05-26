{{- if .Values.codeServer.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
  annotations:
    cert-manager.io/cluster-issuer: kloudlite-cert-issuer

spec:
  {{- if .Values.codeServer.ingress.className }}
  ingressClassName: {{.Values.codeServer.ingress.className}}
  {{- end }}
  rules:
  - host: {{ .Values.codeServer.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{.Release.Name}}
            port:
              number: 8000
  tls:
  - hosts:
    - {{ .Values.codeServer.ingress.host }}
    secretName: {{ .Values.codeServer.ingress.host }}-tls
{{- end }}