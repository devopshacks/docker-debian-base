#!/usr/bin/env bash

set -eo pipefail; [[ "$DOCKER_ENTRYPOINT_TRACE" ]] && set -x

if [[ "$(id -u)" -ne 0 ]]; then
    echo 'docker_entrypoint.sh requires root' >&2
    exit 1
fi

echo "Run confd with prefix ${CONFD_PREFIX}"
confd -onetime -prefix ${CONFD_PREFIX} ${CONFD_OPTIONS}

exec gosu ${USER} "$@"
