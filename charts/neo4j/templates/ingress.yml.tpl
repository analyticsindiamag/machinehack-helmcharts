{{- if .Values.custom.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-neo4j
  namespace: {{ .Release.Namespace }}
  annotations:
    cert-manager.io/cluster-issuer: kloudlite-cert-issuer

spec:
  {{- if .Values.custom.ingress.className }}
  ingressClassName: {{.Values.custom.ingress.className}}
  {{- end }}
  rules:
  - host: {{ .Values.custom.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{.Release.Name}}-neo4j
            port:
              number: 7474
  tls:
  - hosts:
    - {{ .Values.custom.ingress.host }}
    secretName: {{ .Values.custom.ingress.host }}-tls
{{- end }}
