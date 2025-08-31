{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount -}}
    {{ .Values.serviceAccount.name | default (include "common.fullname" .) }}
{{- else -}}
    {{ "default" }}
{{- end -}}
{{- end -}}

{{/*
Define a common ServiceAccount resource.
*/}}
{{- define "common.serviceaccount" -}}
{{- if .Values.serviceAccount -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "common.serviceAccountName" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end -}}
