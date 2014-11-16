FROM scratch
MAINTAINER Jean-Francois Richard <jf.richard@heimdalsgata.com>
ADD tmp/nix-archive/store/*-bash-*/bin/bash /bin/sh
ADD tmp/nix-archive/store /nix/store
ADD tmp/nix-archive/.reginfo /root/reginfo
# Just to create /tmp (we don't have mkdir yet):
ADD tmp/nix-archive/.reginfo /tmp/reginfo
WORKDIR /root
ENV HOME /root
ENV USER root
RUN \
  /nix/store/*-nix-*/bin/nix-store --init                        &&\
  /nix/store/*-nix-*/bin/nix-store --load-db < /root/reginfo     &&\
  /nix/store/*-nix-*/bin/nix-store --optimise                    &&\
  . /nix/store/*-nix-*/etc/profile.d/nix.sh                      &&\
  /nix/store/*-nix-*/bin/nix-env -i                                \
    /nix/store/*-nix-*                                             \
    /nix/store/*-coreutils-*                                       \
    /nix/store/*-bash-*                                          &&\
  rm /root/reginfo /tmp/* /bin/*                                 &&\
  echo '#!/root/.nix-profile/bin/bash'             >> /bin/nixdo &&\
  echo '. /root/.nix-profile/etc/profile.d/nix.sh' >> /bin/nixdo &&\
  echo '/root/.nix-profile/bin/bash -c "$*"'       >> /bin/nixdo &&\
  chmod +x /bin/nixdo                                            &&\
  ln -s /root/.nix-profile/bin/bash /bin/sh                      &&\
  mkdir -p /usr/bin                                              &&\
  ln -s /root/.nix-profile/bin/env /usr/bin/env
ENTRYPOINT ["/bin/nixdo"]
CMD ["/bin/nixdo", "bash" ]
