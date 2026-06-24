#!/bin/bash

set -euo pipefail

IMAGE="brainscanai:dev"

COMMON_FLAGS=(
    --ipc=host
    --ulimit memlock=-1
    --ulimit stack=67108864
    -v "$(pwd):/workspace"
    -v "$HOME/.cache/huggingface:/root/.cache/huggingface"
    -e "HF_TOKEN=${HF_TOKEN:-}"
    -e "PYTHONDONTWRITEBYTECODE=1"
    -w /workspace
)

# Ensure the HF cache directory exists on the host (else Docker creates it as root)
mkdir -p "$HOME/.cache/huggingface"

# Default to "shell" mode if no argument is provided to ./run_container.sh
mode="${1:-shell}"

case "$mode" in

    # "shell" is the default mode, so that running ./run_container.sh without arguments drops you into a bash shell inside the container.
    shell)
        docker run --rm -it --gpus all "${COMMON_FLAGS[@]}" "$IMAGE" bash
        ;;

    # "exec" allows you to run a single command inside the container without starting an interactive shell, e.g. "./run_container.sh exec pytest"
    exec)
        shift
        if [ $# -eq 0 ]; then
            echo "exec requires a command, e.g. ./run_container.sh exec pytest" >&2
            exit 1
        fi
        docker run --rm "${COMMON_FLAGS[@]}" "$IMAGE" "$@"
        ;;

   # "jupyter" starts JupyterLab in detached mode, mapping port 8888 to the host. It also sets up Jupyter with no token or password for easy access. Logs can be viewed with "./run_container.sh logs jupyter" and the container can be stopped with "./run_container.sh stop jupyter".
    jupyter)
        # Remove any existing container with the same name to avoid conflicts - idempotent restart (=restarts the container even if another is running). 
        docker rm -f scirex-jupyter >/dev/null 2>&1 || true
        docker run -d --name scirex-jupyter \
            --gpus all \
            "${COMMON_FLAGS[@]}" \
            -p 127.0.0.1:8888:8888 \
            "$IMAGE" \
            jupyter lab \
                --ip=0.0.0.0 --port=8888 --no-browser --allow-root 
        # Wait for Jupyter to print its startup URL (max ~15s), then show it
        echo "Waiting for Jupyter to start..."
        for i in {1..15}; do
            url=$(docker exec scirex-jupyter jupyter server list 2>/dev/null \
                    | grep -oE 'http://[^ ]+' | head -1 || true)
            if [ -n "$url" ]; then
                # Replace 0.0.0.0 with localhost since we bound to 127.0.0.1
                echo "JupyterLab URL (paste into VS Code):"
                # Replace whatever hostname Jupyter printed (0.0.0.0, container ID, etc.) with localhost
                echo "  ${url/http:\/\/*:8888/http:\/\/localhost:8888}"
                break
            fi
            sleep 1
        done
        echo "Stop with:  ./run_container.sh stop jupyter"
        echo "Logs with:  ./run_container.sh logs jupyter"
        ;;

    # "logs" allows you to follow logs from a detached container by name, e.g. "./run_container.sh logs jupyter" or "./run_container.sh logs streamlit"
    logs)
        target="${2:-}"
        if [ -z "$target" ]; then
            echo "logs requires a target, e.g. logs jupyter" >&2
            exit 1
        fi
        docker logs -f "scirex-${target}"
        ;;

    # "build" allows you to rebuild the Docker image after making changes to the Dockerfile or dependencies, e.g. "./run_container.sh build"
    build)
        docker build -t "$IMAGE" .
        ;;

    help|-h|--help)
        sed -n '2,12p' "$0"
        ;;

    # Catch-all for unknown modes - prints an error message and usage instructions
    *)
        echo "Unknown mode: $mode" >&2
        echo "Run './run_container.sh help' for usage." >&2
        exit 1
        ;;
esac