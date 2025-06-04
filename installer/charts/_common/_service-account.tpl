{{- define "common.serviceAccount" -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
{{- end }}
{{- define "common.secretRWRoleBinding" -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ printf "%s-secret-rw" .Release.Name }}
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
rules:
  - apiGroups:
      - ""
    resources:
      - secrets
    verbs:
      - get
      - list
      - create
      - delete
      - update
      - patch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ printf "%s-secret-rw" .Release.Name }}
  namespace: {{ .Release.Namespace }}
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ printf "%s-secret-rw" .Release.Name }}
subjects:
  - kind: ServiceAccount
    name: {{ .Release.Name }}
    namespace: {{ .Release.Namespace }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ printf "%s-tssc-secret-rw" .Release.Name }}
  namespace: tssc
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ printf "%s-secret-rw" .Release.Name }}
subjects:
  - kind: ServiceAccount
    name: {{ .Release.Name }}
    namespace: {{ .Release.Namespace }}
{{- end }}
{{- define "common.clusterRole" -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ .Release.Name }}
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
rules:
  - apiGroups:
      - "*"
    resources:
      - pods
      - jobs
      - customresourcedefinitions
      - deployments
      - statefulsets
      - routes
      - keycloakrealmimports
    verbs:
      - get
      - list
      - watch
{{- end }}
{{- define "common.clusterRoleBinding" -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ .Release.Name }}
  labels: {{- include "common.postDeployDeleteLabels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ .Release.Name }}
subjects:
  - kind: ServiceAccount
    name: {{ .Release.Name }}
    namespace: {{ .Release.Namespace }}
{{- end }}
