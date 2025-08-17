{{/*
Define the common ingress-route resource.
*/}}
{{- define "common.ingress-route" -}}
{{- if .Values.ingress.enabled -}}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: {{ include "common.fullname" . }}-ingress
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  entryPoints:
    - {{ .Values.ingress.entryPoint | default "web" }}
  routes:
    - match: Host(`{{ .Values.ingress.host }}`)
      kind: Rule
      services:
        - name: {{ include "common.fullname" . }}
          port: {{ .Values.service.port }}
          scheme: {{ .Values.ingress.scheme | default "http" }}
{{- end }}
{{- end -}}
