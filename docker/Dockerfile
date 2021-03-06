FROM debian:8

ENV USER=app \
    CONFD_VERSION=0.11.0 \
    CONFD_PREFIX=/ \
    CONFD_OPTIONS="-backend env" \
    DEBIAN_FRONTEND=noninteractive \
    GOSU_VERSION=1.9

RUN \
    echo "Create app user and group" \
    && useradd -u 1000 -U -s /bin/false ${USER} \

    && echo "Install packages" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        make \
        curl \

    && echo "Install gosu" \
    && curl -sSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && curl -sSL -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && echo "Install confd" \
    && curl -sSL https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -o /bin/confd \
    && chmod +x /bin/confd \
    && mkdir -p /etc/confd/{conf.d,templates} \

    && echo "Clean up" \
    && rm -rf /var/lib/apt/lists/* /tmp/*

COPY entrypoint.sh /usr/local/bin/docker-entrypoint
COPY install-dev-tools.sh /usr/local/bin/install-dev-tools
COPY opsidian-logo /etc/opsidian-logo
COPY opsidian-release /etc/opsidian-release

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
