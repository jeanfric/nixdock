FROM scratch
MAINTAINER Jean-Francois Richard <jf.richard@heimdalsgata.com>
ADD tmp/nix-archive /nix/
ADD tmp/nix-archive/store/*-bash-*/bin/bash /bin/sh
WORKDIR /root
ENV HOME /root
ENV USER root
RUN \
  /nix/store/*-coreutils-*/bin/mkdir -p /tmp /usr/bin /var/empty &&\
  /nix/store/*-nix-*/bin/nix-store --init                        &&\
  /nix/store/*-nix-*/bin/nix-store --load-db < /nix/.reginfo     &&\
  . /nix/store/*-nix-*/etc/profile.d/nix.sh                      &&\
  /nix/store/*-nix-*/bin/nix-env --install                         \
    /nix/store/*-nix-*                                             \
    /nix/store/*-coreutils-*                                       \
    /nix/store/*-bash-*                                          &&\
  rm /nix/.reginfo /nix/install /bin/sh                          &&\
  echo '#!/root/.nix-profile/bin/bash'             >  /bin/nixdo &&\
  echo '. /root/.nix-profile/etc/profile.d/nix.sh' >> /bin/nixdo &&\
  echo '/root/.nix-profile/bin/bash -c "$*"'       >> /bin/nixdo &&\
  chmod +x /bin/nixdo                                            &&\
  ln -s /root/.nix-profile/bin/bash /bin/sh                      &&\
  ln -s /root/.nix-profile/bin/false /bin/false                  &&\
  ln -s /root/.nix-profile/bin/env /usr/bin/env                  &&\
  echo "root::0:"          >  /etc/group                         &&\
  echo "nixbld::1:nixbld1" >> /etc/group                         &&\
  echo "root::0:0::/root:/bin/sh"            >  /etc/passwd      &&\
  echo "nixbld1::1:1::/var/empty:/bin/false" >> /etc/passwd      &&\
  mkdir /nix/var/nix/manifests                                   &&\
  nix-collect-garbage                                            &&\
  nix-collect-garbage --delete-old
ENTRYPOINT ["/bin/nixdo"]
CMD ["/bin/nixdo", "bash" ]
