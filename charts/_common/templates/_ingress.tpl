{{/*
Define the common ingress resource for NGINX.
*/}}
{{- define "common.ingress" -}}
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.fullname" . }}-ingress
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  annotations:
    kubernetes.io/ingress.class: nginx
    {{- with .Values.ingress.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  tls:
  - hosts:
    - {{ .Values.ingress.host }}
  rules:
  - host: {{ .Values.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ .Values.ingress.serviceName | default (include "common.fullname" .) }}
            port:
              {{- /*
                This if/else block is required because Helm's 'default' function
                evaluates both arguments, which causes a nil pointer error if
                a chart (like kube-dashboard) does not have a top-level .Values.service block.
              */}}
              {{- if .Values.ingress.servicePort }}
              number: {{ .Values.ingress.servicePort }}
              {{- else }}
              number: {{ .Values.service.port }}
              {{- end }}
{{- end }}
{{- end -}}
