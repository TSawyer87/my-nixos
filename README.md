### Overview

**Commands**:

- `fr`: flake-rebuild, runs `nh os switch /home/${username}/my-nixos`

- `fu`: flake-update, `nh os switch --update /home/${username}/my-nixos`

- `nix build .#nixos`: build and deploy your configuration as a package, rather than by invoking `nixos-rebuild`

- `nix run .#deploy-nixos` build-and-deploy script

- `nix repl .#repl`: Load flake into repl or `nixos-rebuild repl --flake .`

- `nix fmt`: When run in root of flake it will format the whole configuration

- `nix flake check`: Run style check with treefmt-nix

- `nix flake show`: Show the flakes outputs

**Defaults**:

- Editor | helix

- Browser | firefox

- Terminal | ghostty

- PDF | zathura

- Files | yazi
