default: nixdock
.PHONY: nixdock
nixdock:
	wget -O - https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2 | tar -xjf -
	docker build -t nixdock .
available: nixdock
	docker login
	docker tag nixdock jeanfric/nixdock:latest
	docker push jeanfric/nixdock:latest
	docker tag nixdock jeanfric/nixdock:1.7
	docker push jeanfric/nixdock:1.7
