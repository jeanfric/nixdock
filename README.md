nixdock
=======

A bare-bones Docker container with Nix (http://nixos.org/nix) installed and
nothing more.

To build and run nixdock:

```
make nixdock
docker run --tty --interactive nixdock
```

You can also use the ready-made container available on the Docker Hub:

```
docker run --tty --interactive jeanfric/nixdock
```


Inside the container, you can then start installing packages using Nix, after
updating the default channel:

```
nix-channel --list
nix-channel --update

# To use bash-interactive, with readline support (tab, arrow keys working)
nix-env --install bash bash-interactive
exec bash

nix-env --install less
nix-env --query --available | less
```
