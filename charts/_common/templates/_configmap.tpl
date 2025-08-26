{{- define "common.configmap" -}}
{{- if .Values.configmap -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-configmap
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  {{ .Values.configmap.filename }}: |
    {{- toYaml .Values.configmap.data | nindent 4 }}
{{- end -}}
{{- end -}}