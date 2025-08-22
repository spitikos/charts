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
            # Use the override if provided, otherwise default to the standard service name.
            name: {{ .Values.ingress.serviceName | default (include "common.fullname" .) }}
            port:
              # Use the override if provided, otherwise default to the standard service port.
              number: {{ .Values.ingress.servicePort | default .Values.service.port }}
{{- end }}
{{- end -}}