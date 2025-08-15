{{/*
Define the common ingress-route resource.
This template will generate an IngressRouteTCP for gRPC services
and a standard IngressRoute for HTTP services.
*/}}
{{- define "common.ingress-route" -}}
{{- if .Values.ingress.enabled -}}

{{- if eq .Values.ingress.entryPoint "grpc" -}}
# --- IngressRouteTCP for gRPC services ---
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: {{ include "common.fullname" . }}-ingress-route-tcp
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  entryPoints:
    - grpc
  routes:
    # Use HostSNI(`*`) to match any TCP traffic on the entrypoint
    # as gRPC routing is handled by the client, not by hostname.
    - match: HostSNI(`*`)
      services:
        - name: {{ include "common.fullname" . }}
          port: {{ .Values.service.port }}
{{- else -}}

# --- IngressRoute for standard HTTP services ---
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

{{- end }}
{{- end -}}
