{{/*
Define the common service resource.
*/}}
{{- define "common.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.containerPort }}
      protocol: TCP
      name: {{ .Values.service.portName | default "http" }}
      {{- if .Values.service.appProtocol }}
      appProtocol: {{ .Values.service.appProtocol }}
      {{- end }}
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
{{- end -}}
