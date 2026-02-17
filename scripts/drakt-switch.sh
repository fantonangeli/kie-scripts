#!/bin/sh
set -eu

MODE="${1-}"
BRANCH="${2-}"

M2_DIR="$HOME/.m2"
ENV_FILE="$M2_DIR/drakt-env.sh"
SRC_DIR="$M2_DIR/kie-artifacts/$MODE/$BRANCH"

usage() {
  cat <<'USAGE'
Usage:
  drakt-switch [upstream|midstream] <branch>

Examples:
  drakt-switch midstream main
  drakt-switch upstream  9.103.x-prod
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
  upstream|midstream)
    ;;
  *)
    die "Invalid mode '$MODE' (expected: upstream | midstream)"
    ;;
esac

# Validate source
if [ ! -d "$SRC_DIR" ]; then
  die "Artifacts not found: $SRC_DIR"
fi
if [ ! -d "$SRC_DIR/org/kie" ]; then
  die "Missing $SRC_DIR/org/kie"
fi
if [ ! -d "$SRC_DIR/org/apache/kie" ]; then
  die "Missing $SRC_DIR/org/apache/kie"
fi

# Clean current
rm -rf "$M2_DIR/repository/org/kie" "$M2_DIR/repository/org/apache/kie"

# Restore from artifacts
mkdir -p "$M2_DIR/repository/org" "$M2_DIR/repository/org/apache"
cp -a "$SRC_DIR/org/kie" "$M2_DIR/repository/org/"
cp -a "$SRC_DIR/org/apache/kie" "$M2_DIR/repository/org/apache/"

# Update env file
mkdir -p "$M2_DIR"
cat > "$ENV_FILE" <<EOF2
# Used by drakt-build.sh / drakt-switch
DRAKT_CURRENT_MODE='$MODE'
DRAKT_CURRENT_BRANCH='$BRANCH'
EOF2

echo "New DRAKT version: $MODE/$BRANCH"
