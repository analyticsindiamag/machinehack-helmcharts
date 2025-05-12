{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
  annotations:
    cert-manager.io/cluster-issuer: kloudlite-cert-issuer

spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{.Values.ingress.className}}
  {{- end }}
  rules:
  - host: {{ .Values.ingress.host }}
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
    - {{ .Values.ingress.host }}
    secretName: {{ .Values.ingress.host }}-tls
{{- end }}