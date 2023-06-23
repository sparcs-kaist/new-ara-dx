# DinD in Ubuntu, not Alpine
# https://github.com/docker-library/docker/issues/306
# ====Dind Migration Start====
FROM ubuntu:22.04

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		iptables \
		openssl \
		pigz \
		xz-utils \
	; \
	rm -rf /var/lib/apt/lists/*

ENV DOCKER_TLS_CERTDIR=/certs
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

COPY --from=docker:dind /usr/local/bin/ /usr/local/bin/
COPY --from=docker:dind /usr/local/libexec/docker/cli-plugins /usr/local/libexec/docker/cli-plugins
# ====Dind Migration Done====

# Essential Packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install netcat-openbsd git vim curl openssh-server awscli -y

COPY ./dind-contents/dind-entrypoint.sh /dind-entrypoint.sh
COPY ./dind-contents/root-ara /root/ara

ENTRYPOINT ["bash", "/dind-entrypoint.sh"]