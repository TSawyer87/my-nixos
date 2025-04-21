{
  lib,
  flake,
  pkgs,
}: {
  inherit flake pkgs lib;
  configs = flake.nixosConfigurations;
}
# Accepts `lib`, `flake`, `pkgs` from `flake.nix` as arguments
# Attributes: flake: all flake outputs (flake.outputs, flake.inputs)
# run `nix repl .#repl` to load the REPL environment
# :l <nixpkgs>  # load additional Nixpkgs if needed
# flake.outputs.packages.x86_64-linux.default # inspect default package
# pkgs.helix # access helix package
# lib.version # check lib version
# configs.magic.config.inputs.userVars # inspect variables

