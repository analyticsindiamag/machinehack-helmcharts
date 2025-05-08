apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-haproxy-config
  labels:
    app: haproxy
data:
  haproxy.cfg: |
    global
      daemon
      maxconn 4096
      {{- if .Values.config.compression.enabled }}
      tune.ssl.default-dh-param 2048
      {{- end }}

    defaults
      mode http
      timeout connect 5000ms
      timeout client 50000ms
      timeout server 50000ms
      option httplog
      {{- if .Values.config.compression.enabled }}
      compression algo gzip
      compression type {{ .Values.config.compression.types }}
      {{- end }}

    frontend http-in
      bind *:80
      {{- if and .Values.config.ssl.enabled .Values.config.ssl.redirect }}
      redirect scheme https code 301 if !{ ssl_fc }
      {{- end }}
      {{- if .Values.config.headers.enabled }}
      {{- range $key, $value := .Values.config.headers.add }}
      http-response set-header {{ $key }} "{{ $value }}"
      {{- end }}
      {{- end }}
      default_backend backend_servers

    {{- if .Values.config.ssl.enabled }}
    frontend https-in
      bind *:443 ssl crt /etc/ssl/private/combined.pem
      {{- if .Values.config.headers.enabled }}
      {{- range $key, $value := .Values.config.headers.add }}
      http-response set-header {{ $key }} "{{ $value }}"
      {{- end }}
      {{- end }}
      default_backend backend_servers
    {{- end }}

    {{- if .Values.config.stats.enabled }}
    frontend stats
      bind *:8404
      stats enable
      stats uri {{ .Values.config.stats.uri }}
      stats refresh 10s
      {{- if .Values.config.stats.auth.enabled }}
      stats auth {{ .Values.config.stats.auth.username }}:{{ .Values.config.stats.auth.password }}
      {{- end }}
    {{- end }}

    backend backend_servers
      balance roundrobin
      option httpchk
      http-check send meth GET uri / ver HTTP/1.1 hdr Host {{ .Values.ingress.host }}
      server default {{ .Values.config.defaultBackend }} check 