{
  lib,
  flake,
  pkgs,
}: {
  inherit flake pkgs lib;
  configs = flake.nixosConfigurations;
}
