{{- if .Values.codeServer.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "code-server.name" . }}
  namespace: {{.Release.Namespace}}
  annotations:
    kubernetes.io/ingress.class: {{ .Values.codeServer.ingress.className }}
    {{- if .Values.codeServer.ingress.clusterIssuer }}
    cert-manager.io/cluster-issuer: {{ .Values.codeServer.ingress.clusterIssuer }}
    {{- end }}
    {{- if .Values.codeServer.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ .Values.codeServer.ingress.cors.origins | join "," }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    {{- end }}
spec:
  {{- if .Values.codeServer.ingress.clusterIssuer }}
  tls:
    - hosts:
        - {{ .Values.codeServer.ingress.host }}
      secretName: {{ include "code-server.name" . }}-tls
  {{- end }}
  rules:
    - host: {{ .Values.codeServer.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ include "code-server.name" . }}
                port:
                  number: 80
{{- end }} 