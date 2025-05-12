{{- if .Values.neo4j.ingress.enabled }}
{{- if not .Values.neo4j.ingress.host }}
{{- if not .Release.IsUpgrade }}
{{- fail "A valid ingress.host is required. Please provide a host value in your values or API request" }}
{{- end }}
{{- end }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: {{.Release.Namespace}}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/secure-backends: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    {{- if .Values.neo4j.ingress.tls.enabled }}
    cert-manager.io/cluster-issuer: {{ required "a valid cluster issuer must be provided" .Values.neo4j.ingress.tls.clusterIssuer}}
    {{- end }}
    {{- if .Values.neo4j.ingress.cors.enabled }}
    nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS, DELETE"
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ join "," .Values.neo4j.ingress.cors.origins | quote }}
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
    nginx.ingress.kubernetes.io/cors-allow-headers: "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization"
    {{- end }}
spec:
  {{- if .Values.neo4j.ingress.className }}
  ingressClassName: {{.Values.neo4j.ingress.className}}
  {{- end }}
  rules:
  {{- if .Values.neo4j.ingress.host }}
  - host: {{ .Values.neo4j.ingress.host }}
    http:
      paths:
      - path: {{ .Values.neo4j.ingress.path }}(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: {{.Release.Name}}
            port:
              number: 7474
  {{- end }}
  {{- if and .Values.neo4j.ingress.tls.enabled .Values.neo4j.ingress.host }}
  tls:
  - hosts:
    - {{ .Values.neo4j.ingress.host }}
    secretName: {{ .Values.neo4j.ingress.host | replace "." "-" }}-tls
  {{- end }}
{{- end }}