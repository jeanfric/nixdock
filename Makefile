VERSION=1.7

default: nixdock

tmp/nix-archive:
	mkdir -p tmp/nix-archive
	wget -O - https://nixos.org/releases/nix/nix-$(VERSION)/nix-$(VERSION)-x86_64-linux.tar.bz2 | tar --strip-components 1 -C tmp/nix-archive -xjf -

nixdock: tmp/nix-archive
	docker build -t nixdock .

available: nixdock
	docker login
	docker tag nixdock jeanfric/nixdock:latest
	docker push jeanfric/nixdock:latest
	docker tag nixdock jeanfric/nixdock:$(VERSION)
	docker push jeanfric/nixdock:$(VERSION)
