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
  replicas: {{ .Values.deployment.replicaCount }}
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- if or .Values.deployment.podAnnotations .Values.configmap }}
      annotations:
        {{- with .Values.deployment.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- if .Values.configmap }}
        checksum/config: {{ toYaml .Values.configmap.data | sha256sum }}
        {{- end }}
      {{- end }}
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.serviceAccount }}
      serviceAccountName: {{ include "common.serviceAccountName" . }}
      {{- end }}
      containers:
        - name: {{ include "common.fullname" . }}
          image: "{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag }}"
          imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
          ports:
            - name: {{ .Values.service.portName | default "http" }}
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          {{- with .Values.deployment.env }}
          env:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.deployment.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if .Values.configmap }}
          volumeMounts:
            - name: config
              mountPath: {{ .Values.configmap.mountDir }}
          {{- end }}
      {{- if .Values.configmap }}
      volumes:
        - name: config
          configMap:
            name: {{ include "common.fullname" . }}-configmap
      {{- end }}
{{- end -}}
