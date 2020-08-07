FROM roninkenji/slackware-base:latest
LABEL maintainer=roninkenji

RUN mkdir -p /dropbox
WORKDIR /dropbox
EXPOSE 17500
EXPOSE 17500/udp

RUN slackpkg update && \
    slackpkg -batch=on -default_answer=yes install \
    cxxlibs gcc-[0-9] \
    glibc-[0-9] \
    shadow \
    python-2.7 \
    mesa \
    libX11 \
    libXau \
    libxcb \
    libXdamage \
    libXdmcp \
    libXext \
    libXfixes \
    libxshmfence \
    libXxf86vm

#RUN wget -nv -O /usr/local/bin/dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py && chmod +x /usr/local/bin/dropbox.py
RUN wget -nv -O- https://www.dropbox.com/download?plat=lnx.x86_64 | tar -C /usr/local -zx && chown -Rv root:root /usr/local/.dropbox-dist
RUN wget -O /dropbox/proxychains-4.14-x86_64-1_slonly.txz https://packages.slackonly.com/pub/packages/14.2-x86_64/network/proxychains/proxychains-4.14-x86_64-1_slonly.txz

ADD dropbox.py /usr/local/bin/dropbox.py
ADD dockerinit.sh /usr/local/bin/
RUN upgradepkg --install-new /dropbox/proxychains-4.14-x86_64-1_slonly.txz
RUN chmod +x /usr/local/bin/dropbox.py /usr/local/bin/dockerinit.sh

ENTRYPOINT ["/usr/local/bin/dockerinit.sh"]
