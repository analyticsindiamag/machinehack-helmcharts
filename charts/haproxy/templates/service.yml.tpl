apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-haproxy
  labels:
    app: haproxy
spec:
  type: {{ .Values.service.type }}
  ports:
    - name: http
      port: {{ .Values.service.ports.http.port }}
      targetPort: {{ .Values.service.ports.http.targetPort }}
    {{- if .Values.config.stats.enabled }}
    - name: stats
      port: {{ .Values.service.ports.stats.port }}
      targetPort: {{ .Values.service.ports.stats.targetPort }}
    {{- end }}
  selector:
    app: haproxy 