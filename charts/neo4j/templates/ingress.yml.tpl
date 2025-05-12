{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    {{- if .Values.ingress.tls.enabled }}
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.ingress.tls.clusterIssuer}}
    {{- end }}
    {{- if .Values.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS, DELETE"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ join "," .Values.ingress.cors.origins | quote }}
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization"
    {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{.Values.ingress.className}}
  {{- end }}
  rules:
  - host: {{ .Values.ingress.host }}
    http:
      paths:
      - path: {{ .Values.ingress.path }}(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: {{.Release.Name}}
            port:
              number: 7474
  tls:
  - hosts:
    - {{ .Values.ingress.host }}
    secretName: {{ .Values.ingress.host }}-tls
{{- end }}