#!/usr/bin/env bash

set -eo pipefail; [[ "$TRACE" ]] && set -x

if [[ "$(id -u)" -ne 0 ]]; then
    echo 'docker_entrypoint.sh requires root' >&2
    exit 1
fi

function info {
    cat /etc/opsidian-logo
    echo
    cat /etc/opsidian-release
}

function init_wrapper {
    init >> /var/log/docker-init.log 2>&1
    if [ -n "$exit_code" ]; then
        cat /var/log/docker-init.log >&2
        exit $exit_code
    fi
}

function init {
    . /etc/profile || exit_code=$?
    confd -onetime -prefix ${CONFD_PREFIX} ${CONFD_OPTIONS} || exit_code=$?
    [ ! -f /usr/local/bin/docker-init ] || docker-init || exit_code=$?
}

function install_dev_tools {
    echo "Install dev tools"
    install-dev-tools
}

case "$@" in
    docker-info)
        info
        exit 0
        ;;
    *)
        init_wrapper
        [ -z "${INSTALL_DEV_TOOLS}" ] || install_dev_tools
        exec gosu ${USER} "$@"
        ;;
esac
