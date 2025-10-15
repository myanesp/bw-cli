# syntax=docker/dockerfile:1
FROM debian:stable-slim

ARG VERSION=2025.9.0
ENV VERSION=${VERSION}

ENV PATH=/usr/local/bin:$PATH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl unzip; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    DL_URL="$(curl -sL "https://api.github.com/repos/bitwarden/clients/releases/tags/cli-v${VERSION}" | \
        grep -oE "https://[^\"]+oss-linux-${VERSION}\.zip" | head -n1)"; \
    if [ -z "$DL_URL" ]; then echo "Failed to find download URL for bw-cli ${VERSION}"; exit 1; fi; \
    curl -fsSL "$DL_URL" -o /tmp/bw.zip; \
    unzip /tmp/bw.zip -d /tmp; \
    mv /tmp/bw /usr/local/bin/bw; \
    chmod +x /usr/local/bin/bw; \
    rm -rf /tmp/bw.zip /tmp/*

WORKDIR /data

CMD ["sh","-c","tail -f /dev/null"]
