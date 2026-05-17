FROM kasmweb/core-debian-bookworm:1.18.0

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    STARTUPDIR=/dockerstartup \
    PATH=/home/kasm-user/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG MIHOMO_VERSION=v1.19.16
ARG GOST_VERSION=2.12.0
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gzip \
        python3 \
        python3-venv \
        tar \
        unzip \
        wget \
        sudo \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*

RUN command -v curl \
    && curl --version
    
ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && install -m 0755 $HOME/.local/bin/uv /usr/local/bin/uv \
    && install -m 0755 $HOME/.local/bin/uvx /usr/local/bin/uvx \
    && uv --version

RUN set -eux; \
    arch="${TARGETARCH:-amd64}"; \
    case "$arch" in \
        amd64) mihomo_arch="amd64" ;; \
        arm64) mihomo_arch="arm64" ;; \
        *) echo "unsupported TARGETARCH: $arch" >&2; exit 1 ;; \
    esac; \
    wget -O /tmp/mihomo.gz "https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_VERSION}/mihomo-linux-${mihomo_arch}-${MIHOMO_VERSION}.gz"; \
    gzip -d /tmp/mihomo.gz; \
    install -m 0755 /tmp/mihomo /usr/local/bin/mihomo; \
    rm -f /tmp/mihomo; \
    mihomo -v

RUN set -eux; \
    arch="${TARGETARCH:-amd64}"; \
    case "$arch" in \
        amd64|arm64) gost_arch="$arch" ;; \
        *) echo "unsupported TARGETARCH: $arch" >&2; exit 1 ;; \
    esac; \
    wget -O /tmp/gost.tar.gz "https://github.com/ginuerzh/gost/releases/download/v${GOST_VERSION}/gost_${GOST_VERSION}_linux_${gost_arch}.tar.gz"; \
    tar -xzf /tmp/gost.tar.gz -C /usr/local/bin gost; \
    chmod +x /usr/local/bin/gost; \
    rm -f /tmp/gost.tar.gz; \
    gost -V

RUN chown -R 1000:0 $HOME

COPY start-app.sh /dockerstartup/custom_startup.sh
RUN chmod +x /dockerstartup/custom_startup.sh

EXPOSE 6901

USER 1000
