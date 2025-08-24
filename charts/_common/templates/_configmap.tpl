{{/*
Define a common ConfigMap resource.
*/}}
{{- define "common.configmap" -}}
{{- if .Values.config }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-configmap
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  {{ .Values.config.filename }}: |
    {{- toYaml .Values.config.data | nindent 4 }}
{{- end -}}
{{- end -}}