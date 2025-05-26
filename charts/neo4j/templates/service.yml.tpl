apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-neo4j
  namespace: {{ .Release.Namespace }}
spec:
  selector:
    app: {{ .Release.Name }}-neo4j
  ports:
    - name: http
      protocol: TCP
      port: 7474       
      targetPort: 7474
    - name: bolt
      protocol: TCP
      port: 7687       
      targetPort: 7687
  type: ClusterIP   