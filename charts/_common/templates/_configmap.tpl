{{- define "common.configmap" -}}
{{- if .Values.config.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  {{ .Values.config.filename }}: |
    {{- toYaml .Values.config.data | nindent 4 }}
{{- end }}
{{- end -}}
