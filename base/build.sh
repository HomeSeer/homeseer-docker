#!/bin/bash -e

############################################
# HOMESEER LINUX BASE IMAGE BUILD SCRIPT
############################################

MODE="push"
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            shift 2
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

VERSION="${BASE_VERSION:?BASE_VERSION environment variable is required}"
IMAGE_NAME="${IMAGE_NAME:?IMAGE_NAME environment variable is required}"

echo
echo "**********************************************************************"
echo "* BUILDING HOMESEER LINUX BASE DOCKER IMAGE                          *"
echo "**********************************************************************"
echo

docker buildx create \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10485760 \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 \
    --use \
    --name homeseer-builder >/dev/null 2>&1 || true

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

docker buildx build \
    --progress=plain \
    --build-arg BUILDDATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg VERSION="$VERSION" \
    --platform "$PLATFORM" \
    $OUTPUT \
    --tag "${IMAGE_NAME}:${VERSION}" \
    --tag "${IMAGE_NAME}:latest" \
    . "${EXTRA_ARGS[@]}"