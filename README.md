### Overview

**Commands**:

- `fr`: flake-rebuild, runs `nh os switch /home/${username}/my-nixos`

- `fu`: flake-update, `nh os switch --update /home/${username}/my-nixos`

- `nix build .#nixos`: build and deploy your configuration as a package, rather than by invoking `nixos-rebuild`. This will build an executable in
  `./result/bin/switch-to-configuration` You need to run `sudo ./result/bin/switch-to-configuration switch` to load the environment.

- `nix run .#deploy-nixos` build-and-deploy script

- `nix build .#nixos-vm`: build and deploy your configuration in a vm. Launch the vm executable with `sudo result/bin/run-magic-vm` (your hostname will go where `magic` is placed). The configuration for the vm is in `~/my-nixos/lib/vms/nixos-vm.nix`

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
