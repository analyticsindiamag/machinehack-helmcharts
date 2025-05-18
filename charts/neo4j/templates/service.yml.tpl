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
      port: 7474       # Neo4j Browser/HTTP port
      targetPort: 7474
    - name: bolt
      protocol: TCP
      port: 7687       # Neo4j Bolt protocol port
      targetPort: 7687
  type: ClusterIP   