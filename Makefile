VERSION=1.7
URL=https://nixos.org/releases/nix/nix-$(VERSION)/nix-$(VERSION)-x86_64-linux.tar.bz2
SHA512SUM=34cb0a9af472522eaa53f5534dd19292ef277f8774e26b03d8eca0b3fcd2cae5d9147e21edbcaf76d0a2397c95d9793fb67d9395650f7a5d24a9eda1a8346e6a

.PHONY: default

default: nixdock

tmp:
	mkdir -p "$@"

tmp/nix.tar.bz2: tmp
	wget -O tmp/nix.tar.bz2 "$(URL)"
	cat tmp/nix.tar.bz2 | sha512sum - |                   \
	  if ! grep --quiet --regexp "^$(SHA512SUM) " -; then \
	    echo 'hash mismatch' >&2; exit 1;                 \
	  fi

tmp/nix-archive: tmp/nix.tar.bz2
	mkdir -p "$@"
	tar --strip-components 1 -C tmp/nix-archive -xjf tmp/nix.tar.bz2

nixdock: tmp/nix-archive
	docker build -t nixdock .

available: nixdock
	docker login
	docker tag nixdock jeanfric/nixdock:latest
	docker push jeanfric/nixdock:latest
	docker tag nixdock jeanfric/nixdock:$(VERSION)
	docker push jeanfric/nixdock:$(VERSION)
