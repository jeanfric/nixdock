FROM scratch
MAINTAINER Jean-Francois Richard <jf.richard@heimdalsgata.com>
ADD nix-1.7-x86_64-linux/store/8qhilznm4abzjvnbkqi48zy6wrljgi80-bash-4.2-p45/bin/bash /bin/sh
ADD nix-1.7-x86_64-linux/store /nix/store
ADD nix-1.7-x86_64-linux/.reginfo /root/reginfo
# Just to create /tmp (we don't have mkdir yet):
ADD nix-1.7-x86_64-linux/.reginfo /tmp/reginfo
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
  ln -s /root/.nix-profile/bin/bash /bin/sh                      &&\
  chmod +x /bin/nixdo
ENTRYPOINT ["/bin/nixdo"]
CMD ["/bin/nixdo", "bash" ]
