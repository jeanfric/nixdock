nixdock
=======

A bare-bones Docker container with Nix (http://nixos.org/nix) installed and
nothing more.

To build and start nixdock:

```
make nixdock
docker run -it nixdock
```

You can also use the ready-made container available on the Docker Hub:

```
docker run -it jeanfric/nixdock
```


Inside the container, you can then start installing packages using Nix, after
updating the default channel:

```
nix-channel --list
nix-channel --update
nix-env -i less vim
nix-env -qa | less
```
