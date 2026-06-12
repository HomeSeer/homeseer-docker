#!/bin/bash -e

############################################
# HOMESEER (V4) LINUX - DOCKER BUILD SCRIPT
############################################

# ----------------------------
# Defaults
# ----------------------------
MODE="push"
CHANNEL="release"
EXTRA_ARGS=()

# ----------------------------
# Parse arguments
# ----------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            shift 2
            ;;
        --channel)
            CHANNEL="$2"
            shift 2
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

# ----------------------------
# Required env vars
# ----------------------------
VERSION="${HS_VERSION:?HS_VERSION environment variable is required}"
IMAGE_NAME="${IMAGE_NAME:?IMAGE_NAME environment variable is required}"
DOWNLOAD="https://homeseer.com/updates4/linux_${VERSION//./_}.tar.gz"

# ----------------------------
# Image tags
# ----------------------------
if [ "$CHANNEL" == "beta" ]; then
    CHANNEL_TAG="beta"
else
    CHANNEL_TAG="latest"
fi

# ----------------------------
# Buildx setup (safe on GH Actions)
# ----------------------------
docker buildx create \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10485760 \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 \
    --use \
    --name homeseer-builder >/dev/null 2>&1 || true

# ----------------------------
# Build function
# ----------------------------
build () {
    local VERSION="$1"
    local DOWNLOAD="$2"
    local TAGS="$3"
    shift 3
    local ARGS=("$@")

    # mode handling
    if [ "$MODE" == "load" ]; then
        PLATFORM="linux/amd64"
        OUTPUT="--load"
    elif [ "$MODE" == "push" ]; then
        PLATFORM="linux/amd64,linux/arm64"
        OUTPUT="--push"
    else
        echo "Invalid mode: $MODE (use load or push)"
        exit 1
    fi

    echo ""
    echo "======================================="
    echo " Building HomeSeer $VERSION"
    echo " Channel : $CHANNEL"
    echo " Mode    : $MODE"
    echo " Platform: $PLATFORM"
    echo " Image   : $IMAGE_NAME"
    echo "======================================="
    echo ""

    docker buildx build \
        --build-arg BUILDDATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
        --build-arg VERSION="$VERSION" \
        --build-arg DOWNLOAD="$DOWNLOAD" \
        --platform "$PLATFORM" \
        $OUTPUT \
        $TAGS \
        . "${ARGS[@]}"
}

# ----------------------------
# Build invocation
# ----------------------------

build \
    "$VERSION" \
    "$DOWNLOAD" \
    "--tag ${IMAGE_NAME}:${VERSION} --tag ${IMAGE_NAME}:${CHANNEL_TAG}" \
    "${EXTRA_ARGS[@]}"