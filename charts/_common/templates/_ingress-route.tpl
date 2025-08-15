{{/*
Define the common ingress-route resource.
*/}}
{{- define "common.ingress-route" -}}
{{- if .Values.ingress.enabled -}}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: {{ include "common.fullname" . }}-ingress-route
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  entryPoints:
    - {{ .Values.ingress.entryPoint | default "web" }}
  routes:
    - match: Host(`{{ .Values.ingress.host }}`) && PathPrefix(`{{ .Values.ingress.path }}`)
      kind: Rule
      services:
        - name: {{ include "common.fullname" . }}
          port: {{ .Values.service.port }}
          {{- if .Values.ingress.scheme }}
          scheme: {{ .Values.ingress.scheme }}
          {{- end }}
      {{- if .Values.ingress.middleware.enabled }}
      middlewares:
        - name: {{ include "common.fullname" . }}-middleware
          namespace: {{ .Release.Namespace }}
      {{- end }}
{{- end }}
{{- end -}}
