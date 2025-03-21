{{/*
Return the environment value.
*/}}
{{- define "e-commerce-backend-app.env" -}}
  {{- default "dev" .Values.env.env -}}
{{- end -}}

{{/*
Return the application name.
*/}}
{{- define "e-commerce-backend-app.appName" -}}
  {{- default "e-commerce" .Values.env.appName -}}
{{- end -}}

{{/*
Compute the base name by combining env and appName.
Example: "dev-e-commerce"
*/}}
{{- define "e-commerce-backend-app.name" -}}
  {{- printf "%s-%s" (include "e-commerce-backend-app.env" .) (include "e-commerce-backend-app.appName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified app name.
If the release name is the same as the computed name, just use that.
Otherwise, prepend the release name.
*/}}
{{- define "e-commerce-backend-app.fullname" -}}
  {{- $name := include "e-commerce-backend-app.name" . -}}
  {{- if eq .Release.Name $name -}}
    {{- $name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Common labels for all resources.
*/}}
{{- define "e-commerce-backend-app.labels" -}}
app.kubernetes.io/name: {{ include "e-commerce-backend-app.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
