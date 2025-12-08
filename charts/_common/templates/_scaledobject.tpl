{{/*
Define a common KEDA ScaledObject resource.
This allows applications to be scaled based on Prometheus metrics.
*/}}
{{- define "common.scaledobject" -}}
{{- if .Values.scaledobject -}}
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "common.fullname" . }}-scaledobject
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    name: {{ include "common.fullname" . }}-deployment
  minReplicaCount: {{ .Values.scaledobject.minReplicas | default 0 }}
  maxReplicaCount: {{ .Values.scaledobject.maxReplicas | default 5 }}
  pollingInterval: {{ .Values.scaledobject.pollingInterval | default 30 }}
  cooldownPeriod: {{ .Values.scaledobject.cooldownPeriod | default 300 }}
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090
      query: {{ .Values.scaledobject.prometheus.query | quote }}
      threshold: {{ .Values.scaledobject.prometheus.threshold | quote }}
{{- end -}}
{{- end -}}
