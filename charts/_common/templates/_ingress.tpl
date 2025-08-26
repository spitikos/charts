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
    {{- with .Values.ingress.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  ingressClassName: {{ .Values.ingress.className | default "nginx" }}
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
              {{- if .Values.ingress.servicePort }}
              number: {{ .Values.ingress.servicePort }}
              {{- else }}
              number: {{ .Values.service.port }}
              {{- end }}
{{- end -}}
{{- end -}}
