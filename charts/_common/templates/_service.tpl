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
  {{- if eq .Values.service.portName "grpc" }}
  annotations:
    traefik.ingress.kubernetes.io/service.serversscheme: h2c
  {{- end }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.containerPort }}
      protocol: TCP
      name: {{ .Values.service.portName }}
      {{- if .Values.service.appProtocol }}
      appProtocol: {{ .Values.service.appProtocol }}
      {{- end }}
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
{{- end -}}
