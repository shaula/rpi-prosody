FROM resin/rpi-raspbian

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev \
      lua5.1 \
      lua-dbi-sqlite3 \
      lua-dbi-mysql \
      lua-dbi-postgresql \
      lua-event \
      lua-expat \
      lua-filesystem \
      lua-socket \
      lua-sec \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PROSODY_VERSION 0.9.11
ENV PROSODY_DOWNLOAD_URL https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz
ENV PROSODY_DOWNLOAD_SHA1 1cd50597a166300af06654f6c75dd38e296b7d83

RUN buildDeps='gcc libc6-dev make liblua5.1-dev libidn11-dev libssl-dev' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 && wget -O prosody.tar.gz "${PROSODY_DOWNLOAD_URL}" \
 && echo "${PROSODY_DOWNLOAD_SHA1} *prosody.tar.gz" | sha1sum -c - \
 && mkdir -p /usr/src/prosody \
 && tar -xzf prosody.tar.gz -C /usr/src/prosody --strip-components=1 \
 && rm prosody.tar.gz \
 && cd /usr/src/prosody && ./configure --ostype=debian \
 && make -C /usr/src/prosody \
 && make -C /usr/src/prosody install \
 && rm -r /usr/src/prosody \
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
        mam `# message archive management (XEP-0313)` \
        smacks `# stream management (XEP-0198)` \
        throttle_presence `# presence throttling in CSI`

USER prosody

ENTRYPOINT ["/entrypoint.sh"]
CMD ["prosody"]
