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
      stats socket /var/run/haproxy.sock mode 600 level admin
      stats timeout 2m

    defaults
      mode http
      timeout connect 5000ms
      timeout client 50000ms
      timeout server 50000ms
      log global
      option httplog

    frontend http-in
      bind *:80
      default_backend backend_servers

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
      option httpchk GET / HTTP/1.1\r\nHost:\ {{ .Values.ingress.host }}
      server default {{ .Values.config.defaultBackend }} check 