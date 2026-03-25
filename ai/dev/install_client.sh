#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "${SCRIPT_DIR}/../.." || exit 1

build/sbt pythonClient/generate

CLIENT_TARGET_DIR="./clients/python/target"
if [ ! -d "$CLIENT_TARGET_DIR" ]; then
    log "Error: Client target directory '$CLIENT_TARGET_DIR' does not exist."
    exit 1
fi

# Install the current branch's unitycatalog-client package
# (relies on VIRTUAL_ENV being set by the caller)
# Note: unitycatalog-ai core is managed by the uv workspace as an editable install;
# reinstalling it here as a wheel would overwrite the editable install and remove test_utils.
uv pip install "$CLIENT_TARGET_DIR/.[dev]"
