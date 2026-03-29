#!/bin/bash
# Error handling (Omarchy-style)
set -eEo pipefail

trap 'error "Error on line $LINENO in $(basename ${BASH_SOURCE[1]})" >&2' ERR
