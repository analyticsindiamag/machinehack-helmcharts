apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-exports-create-job-{{ randAlpha 5 | lower }}
  namespace: "kloudlite"
  annotations:
    "helm.sh/hook": post-install, post-upgrade
    "helm.sh/hook-delete-policy": before-hook-creation, hook-succeeded
spec:
  template:
    spec:
      restartPolicy: Never
      serviceAccountName: kloudlite-cluster-admin
      containers:
        - name: post-job
          image: ghcr.io/kloudlite/hub/kubectl:latest
          command: ["bash", "-c"]
          args:
            - |+
              jenkins_user=$(kubectl get secret {{ .Release.Name }} -n {{ .Release.Namespace }} -o json | jq -r '.data."jenkins-admin-user"' | base64 -d)
              jenkins_pass=$(kubectl get secret {{ .Release.Name }} -n {{ .Release.Namespace }} -o json | jq -r '.data."jenkins-admin-password"' | base64 -d)
              port=$(kubectl get svc/{{ .Release.Name }}-nodeport -n {{ .Release.Namespace }} -o json | jq '.spec.ports[] | select (.name == "jenkins") | .nodePort')

              cat <<EOF | kubectl apply -f -
              apiVersion: v1
              kind: Secret
              metadata:
                name: {{ .Release.Name }}-exports
                namespace: {{ .Release.Namespace }}
              stringData:
                JENKINS_URL: {{ .Values.expose.host }}:\$port
                JENKINS_USER: "\$jenkins_user"
                JENKINS_PASSWORD: "\$jenkins_pass"
              EOF
