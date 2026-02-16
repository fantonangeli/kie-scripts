#!/bin/sh
set -eu

MODE="${1-}"
BRANCH="${2-}"
M2_DIR="$HOME/.m2"
ENV_FILE="$M2_DIR/drakt-env.sh"
BUILD_CMD="mvn clean install -Dquickly -DskipTests -DskipITs"
WORK_DIR="drakt-build-tmp"
ARTIFACTS_DIR="$M2_DIR/kie-artifacts/$MODE/$BRANCH"

usage() {
  cat <<'USAGE'
Usage:
  sh drakt-build.sh [upstream|midstream] <branch>

Examples:
  sh drakt-build.sh midstream main
  sh drakt-build.sh upstream  9.103.x-prod
USAGE
}

die() {
  echo "ERROR: $*" >&2
  echo >&2
  usage >&2
  exit 2
}

case "$MODE" in
  -h|--help|help)
    usage
    exit 0
    ;;
esac

if [ -z "$MODE" ]; then die "Missing required argument: [upstream|midstream]"; fi
if [ -z "$BRANCH" ]; then die "Missing required argument: <branch>"; fi

case "$MODE" in
  midstream)
    DROOLS_REPO_URL="https://github.com/kiegroup/drools"
    KOGITO_RUNTIMES_REPO_URL="https://github.com/kiegroup/kogito-runtimes"
    KOGITO_APPS_REPO_URL="https://github.com/kiegroup/kogito-apps"
    ;;
  upstream)
    DROOLS_REPO_URL="https://github.com/apache/incubator-kie-drools"
    KOGITO_RUNTIMES_REPO_URL="https://github.com/apache/incubator-kie-kogito-runtimes"
    KOGITO_APPS_REPO_URL="https://github.com/apache/incubator-kie-kogito-apps"
    ;;
  *)
    die "Invalid mode '$MODE' (expected: upstream | midstream)"
    ;;
esac


# Start from a clean state for just these groupIds
rm -rf "$M2_DIR/repository/org/kie" "$M2_DIR/repository/org/apache/kie"

rm -rf "$WORK_DIR" 2>/dev/null || true
mkdir -p "$WORK_DIR"

build_repo() {
  name="$1"
  url="$2"

  echo "----------------------------------------------------------------------------------------------------Build $name----------------------------------------------------------------------------------------------------"
  echo "REPO URL: $url"
  git clone --depth 1 --branch "$BRANCH" "$url" "$WORK_DIR/$name"
  (
    cd "$WORK_DIR/$name"
    eval "$BUILD_CMD"
  )
  rm -rf "$WORK_DIR/$name"
}

build_repo "drools" "$DROOLS_REPO_URL"
build_repo "kogito-runtimes" "$KOGITO_RUNTIMES_REPO_URL"
build_repo "kogito-apps" "$KOGITO_APPS_REPO_URL"

# Save what we just built
mkdir -p "$ARTIFACTS_DIR/org" "$ARTIFACTS_DIR/org/apache"
rm -rf "$ARTIFACTS_DIR/org/kie" "$ARTIFACTS_DIR/org/apache/kie" 2>/dev/null || true

cp -a "$M2_DIR/repository/org/kie" "$ARTIFACTS_DIR/org/"
cp -a "$M2_DIR/repository/org/apache/kie" "$ARTIFACTS_DIR/org/apache/"

# Update current selection
mkdir -p "$M2_DIR"
cat > "$ENV_FILE" <<EOF
# Used by drakt-build.sh
DRAKT_CURRENT_MODE='$MODE'
DRAKT_CURRENT_BRANCH='$BRANCH'
EOF

rm -rf "$WORK_DIR" || true
