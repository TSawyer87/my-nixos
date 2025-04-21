let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> {};
in {
  inherit flake;
  pkgs = nixpkgs;
  lib = nixpkgs.lib;
  configs = flake.nixosConfigurations;
  inherit builtins;
}
# {
#   lib,
#   flake,
#   pkgs,
# }: {
#   inherit flake pkgs lib;
#   configs = flake.nixosConfigurations;
# }

