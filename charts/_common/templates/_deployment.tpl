{{/*
Define the common deployment resource.
*/}}
{{- define "common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}-deployment
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- if .Values.config }}
      annotations:
        checksum/config: {{ toYaml .Values.config.data | sha256sum }}
      {{- end }}
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ include "common.fullname" . }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: {{ .Values.service.portName | default "http" }}
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          {{- if .Values.config }}
          volumeMounts:
            - name: config
              mountPath: {{ .Values.config.mountDir }}
          {{- end }}
      {{- if .Values.config }}
      volumes:
        - name: config
          configMap:
            name: {{ include "common.fullname" . }}-configmap
      {{- end }}
{{- end -}}
