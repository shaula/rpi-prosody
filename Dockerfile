FROM resin/rpi-raspbian

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev `# this is no build dependency, but needed for luaevent` \
      lua5.2 \
      lua-bitop \
      lua-expat \
      lua-filesystem \
      lua-socket \
      lua-sec \
      sqlite3 \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PROSODY_VERSION 0.11.1
ENV PROSODY_DOWNLOAD_URL https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz
ENV PROSODY_DOWNLOAD_SHA1 dacce98fda317f5ba3c05842e2d97018d050b435

RUN buildDeps='gcc git libc6-dev libidn11-dev liblua5.2-dev libsqlite3-dev libssl-dev make unzip' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && wget -O prosody.tar.gz "${PROSODY_DOWNLOAD_URL}" \
 && echo "${PROSODY_DOWNLOAD_SHA1} *prosody.tar.gz" | sha1sum -c - \
 && mkdir -p /usr/src/prosody \
 && tar -xzf prosody.tar.gz -C /usr/src/prosody --strip-components=1 \
 && rm prosody.tar.gz \
 && cd /usr/src/prosody && ./configure \
 && make -C /usr/src/prosody \
 && make -C /usr/src/prosody install \
 && cd / && rm -r /usr/src/prosody \
 \
 && mkdir /usr/src/luarocks \
 && cd /usr/src/luarocks \
 && wget https://luarocks.org/releases/luarocks-3.0.4.tar.gz \
 && tar zxpf luarocks-3.0.4.tar.gz \
 && cd luarocks-3.0.4 \
 && ./configure \
 && sudo make bootstrap \
 && cd / && rm -r /usr/src/luarocks \
 \
 && luarocks install luaevent \
 && luarocks install luadbi \
 && luarocks install luadbi-sqlite3 \
 \
 && apt-get purge -y --auto-remove $buildDeps

EXPOSE 5000 5222 5269 5347 5280 5281

RUN groupadd -r prosody \
 && useradd -r -g prosody prosody \
 && chown prosody:prosody /usr/local/var/lib/prosody

# https://github.com/prosody/prosody-docker/issues/25
ENV __FLUSH_LOG yes

VOLUME ["/usr/local/var/lib/prosody"]

COPY prosody.cfg.lua /usr/local/etc/prosody/prosody.cfg.lua
COPY docker-entrypoint.sh /entrypoint.sh
COPY conf.d/*.cfg.lua /usr/local/etc/prosody/conf.d/

COPY docker-prosody-module-* /usr/local/bin/
RUN docker-prosody-module-install \
        blocking `# blocking command (XEP-0191)` \
        carbons `# message carbons (XEP-0280)` \
        csi `# client state indication (XEP-0352)` \
        e2e_policy `# require end-2-end encryption` \
        filter_chatstates `# disable "X is typing" type messages` \
        http_upload `# file sharing (XEP-0363)` \
        smacks `# stream management (XEP-0198)` \
        throttle_presence `# presence throttling in CSI`

USER prosody

ENTRYPOINT ["/entrypoint.sh"]
CMD ["prosody"]

