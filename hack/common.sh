#!/usr/bin/env bash

# shellcheck disable=SC2034
# disable unused variable warnings

TARGET_OS="${TARGET_OS:-linux}"
TARGET_ARCH="${TARGET_ARCH:-amd64}"
HOST_OS="$(go env GOHOSTOS)"
HOST_ARCH="$(go env GOHOSTARCH)"

GO_LINT_IMG_LOCATION="${GO_LINT_IMG_LOCATION:-golangci/golangci-lint}"
GO_LINT_IMG_TAG="${GO_LINT_IMG_TAG:-v1.49.0}"
GO_LINT_IMG="${GO_LINT_IMG:-${GO_LINT_IMG_LOCATION}:${GO_LINT_IMG_TAG}}"

# Current DEV version of the CSV
DEFAULT_CSV_VERSION="4.19.0"
CSV_VERSION="${CSV_VERSION:-${DEFAULT_CSV_VERSION}}"
VERSION="${VERSION:-${CSV_VERSION}}"
LDFLAGS="-X github.com/red-hat-storage/ocs-operator/v4/version.Version=${CSV_VERSION}"

# Tools & binaries versions and locations
LOCALBIN="$(pwd)/bin"
OPERATOR_SDK_VERSION="v1.25.4"
OPERATOR_SDK="${LOCALBIN}/operator-sdk-${OPERATOR_SDK_VERSION}"
OPM_VERSION="v1.28.0"
OPM="${LOCALBIN}/opm-${OPM_VERSION}"
GINKGO="${LOCALBIN}/ginkgo"
GOLANGCI_LINT_VERSION="v1.63.4"
GOLANGCI_LINT="${LOCALBIN}/golangci-lint"
SHELLCHECK_VERSION="v0.9.0"
SHELLCHECK="${LOCALBIN}/shellcheck"

OUTDIR_TEMPLATES="deploy/csv-templates"
OUTDIR_CRDS="$OUTDIR_TEMPLATES/crds"

DEPLOY_YAML_PATH="deploy/deploy-with-olm.yaml"
PROMETHEUS_RULES_PATH="metrics/deploy"

GINKGO_TEST_SUITE="${GINKGO_TEST_SUITE:-ocs}"

# This env var allows developers to point to a custom oc tool that isn't in $PATH
# defaults to just using the 'oc' binary provided in $PATH
OCS_OC_PATH="${OCS_OC_PATH:-oc}"
OCS_FINAL_DIR="deploy/ocs-operator/manifests"
BUNDLEMANIFESTS_DIR="rbac"

OCS_CSV="$OUTDIR_TEMPLATES/ocs-operator.csv.yaml.in"

# We are using rook dowsntream image now, i.e, red-hat-storage/rook code
# and we should continue to use dowsntream image only due to few
# downstream only changes present in rook downstream fork.
LATEST_ROOK_IMAGE="quay.io/ocs-dev/rook-ceph:vmaster-ab4f1ba58"
LATEST_NOOBAA_CORE_IMAGE="quay.io/noobaa/noobaa-core:master-20250326"
LATEST_NOOBAA_DB_IMAGE="quay.io/sclorg/postgresql-15-c9s"
LATEST_CEPH_IMAGE="quay.io/ceph/ceph:v19.2.1"
# TODO: change image once the quay repo is changed
LATEST_MUST_GATHER_IMAGE="quay.io/ocs-dev/ocs-must-gather:latest"

DEFAULT_IMAGE_REGISTRY="quay.io"
DEFAULT_REGISTRY_NAMESPACE="ocs-dev"
DEFAULT_IMAGE_TAG="latest"
DEFAULT_OPERATOR_IMAGE_NAME="ocs-operator"
DEFAULT_OPERATOR_BUNDLE_NAME="ocs-operator-bundle"
DEFAULT_FILE_BASED_CATALOG_NAME="ocs-operator-catalog"
DEFAULT_METRICS_EXPORTER_IMAGE_NAME="ocs-metrics-exporter"
DEFAULT_UX_BACKEND_OAUTH_IMAGE_NAME="openshift/origin-oauth-proxy"
DEFAULT_UX_BACKEND_OAUTH_IMAGE_TAG="4.19.0"

IMAGE_REGISTRY="${IMAGE_REGISTRY:-${DEFAULT_IMAGE_REGISTRY}}"
REGISTRY_NAMESPACE="${REGISTRY_NAMESPACE:-${DEFAULT_REGISTRY_NAMESPACE}}"
OPERATOR_IMAGE_NAME="${OPERATOR_IMAGE_NAME:-${DEFAULT_OPERATOR_IMAGE_NAME}}"
OPERATOR_BUNDLE_NAME="${OPERATOR_BUNDLE_NAME:-${DEFAULT_OPERATOR_BUNDLE_NAME}}"
FILE_BASED_CATALOG_NAME="${FILE_BASED_CATALOG_NAME:-${DEFAULT_FILE_BASED_CATALOG_NAME}}"
METRICS_EXPORTER_IMAGE_NAME="${METRICS_EXPORTER_IMAGE_NAME:-${DEFAULT_METRICS_EXPORTER_IMAGE_NAME}}"
UX_BACKEND_OAUTH_IMAGE_NAME="${UX_BACKEND_OAUTH_IMAGE_NAME:-${DEFAULT_UX_BACKEND_OAUTH_IMAGE_NAME}}"
UX_BACKEND_OAUTH_IMAGE_TAG="${UX_BACKEND_OAUTH_IMAGE_TAG:-${DEFAULT_UX_BACKEND_OAUTH_IMAGE_TAG}}"
IMAGE_TAG="${IMAGE_TAG:-${DEFAULT_IMAGE_TAG}}"

DEFAULT_OPERATOR_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${OPERATOR_IMAGE_NAME}:${IMAGE_TAG}"
DEFAULT_BUNDLE_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${OPERATOR_BUNDLE_NAME}:${IMAGE_TAG}"
DEFAULT_FILE_BASED_CATALOG_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${FILE_BASED_CATALOG_NAME}:${IMAGE_TAG}"
DEFAULT_METRICS_EXPORTER_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${REGISTRY_NAMESPACE}/${METRICS_EXPORTER_IMAGE_NAME}:${IMAGE_TAG}"
DEFAULT_UX_BACKEND_OAUTH_FULL_IMAGE_NAME="${IMAGE_REGISTRY}/${UX_BACKEND_OAUTH_IMAGE_NAME}:${UX_BACKEND_OAUTH_IMAGE_TAG}"

OPERATOR_FULL_IMAGE_NAME="${OPERATOR_FULL_IMAGE_NAME:-${DEFAULT_OPERATOR_FULL_IMAGE_NAME}}"
BUNDLE_FULL_IMAGE_NAME="${BUNDLE_FULL_IMAGE_NAME:-${DEFAULT_BUNDLE_FULL_IMAGE_NAME}}"
FILE_BASED_CATALOG_FULL_IMAGE_NAME="${FILE_BASED_CATALOG_FULL_IMAGE_NAME:-${DEFAULT_FILE_BASED_CATALOG_FULL_IMAGE_NAME}}"
METRICS_EXPORTER_FULL_IMAGE_NAME="${METRICS_EXPORTER_FULL_IMAGE_NAME:-${DEFAULT_METRICS_EXPORTER_FULL_IMAGE_NAME}}"
UX_BACKEND_OAUTH_FULL_IMAGE_NAME="${UX_BACKEND_OAUTH_FULL_IMAGE_NAME:-${DEFAULT_UX_BACKEND_OAUTH_FULL_IMAGE_NAME}}"

CSI_ADDONS_BUNDLE_FULL_IMAGE_NAME="quay.io/csiaddons/k8s-bundle:v0.11.0"
CEPH_CSI_BUNDLE_FULL_IMAGE_NAME="quay.io/ocs-dev/cephcsi-operator-bundle:main-0ac7669"
OCS_CLIENT_BUNDLE_FULL_IMAGE_NAME="quay.io/ocs-dev/ocs-client-operator-bundle:3c618ad"
NOOBAA_BUNDLE_FULL_IMAGE_NAME="quay.io/noobaa/noobaa-operator-bundle:master-20250326"
ROOK_BUNDLE_FULL_IMAGE_NAME="quay.io/ocs-dev/rook-ceph-operator-bundle:master-ab4f1ba58"
KUBE_RBAC_PROXY_FULL_IMAGE_NAME="gcr.io/kubebuilder/kube-rbac-proxy:v0.13.0"

OCS_OPERATOR_INSTALL="${OCS_OPERATOR_INSTALL:-false}"
OCS_CLUSTER_UNINSTALL="${OCS_CLUSTER_UNINSTALL:-false}"
OCS_SUBSCRIPTION_CHANNEL=${OCS_SUBSCRIPTION_CHANNEL:-alpha}
INSTALL_NAMESPACE="${INSTALL_NAMESPACE:-openshift-storage}"
UPGRADE_FROM_OCS_REGISTRY_IMAGE="${UPGRADE_FROM_OCS_REGISTRY_IMAGE:-quay.io/ocs-dev/ocs-registry:4.2.0}"
UPGRADE_FROM_OCS_SUBSCRIPTION_CHANNEL="${UPGRADE_FROM_OCS_SUBSCRIPTION_CHANNEL:-$OCS_SUBSCRIPTION_CHANNEL}"

OCS_MUST_GATHER_DIR="${OCS_MUST_GATHER_DIR:-ocs-must-gather}"
OCP_MUST_GATHER_DIR="${OCP_MUST_GATHER_DIR:-ocp-must-gather}"

# Protobuf
PROTOC_VERSION="3.20.0"
PROTOC_GEN_GO_VERSION="1.26.0"
PROTOC_GEN_GO_GRPC_VERSION="1.1.0"

GRPC_BIN="${LOCALBIN}/grpc"
PROTOC="${GRPC_BIN}/protoc"
PROTO_GOOGLE="${GRPC_BIN}/google/protobuf"
PROTOC_GEN_GO="${GRPC_BIN}/protoc-gen-go"
PROTOC_GEN_GO_GRPC="${GRPC_BIN}/protoc-gen-go-grpc"

# gRPC services
SERVICES=("provider")
