FROM scratch

ADD base.tar.gz /

COPY assemble.sh packages.sh save.sh excludes.txt PKGBUILD-* /usr/local/src/build/
COPY hooks/ /etc/initramfs-tools/hooks/
COPY scripts/ /etc/initramfs-tools/scripts/
COPY patches/patch-*/ /usr/local/live/patch/
COPY packages.sh.d/ /usr/local/src/build/packages.sh.d/
COPY debs/ /usr/local/src/build/debs/

ENV TZ=Europe/Kiev DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C

ENV MAIN_PACKAGE=kubuntu-desktop

ENTRYPOINT ["/usr/local/src/build/assemble.sh"]
