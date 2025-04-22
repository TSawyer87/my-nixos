{
  inputs,
  system,
  userVars,
  host,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system;
  specialArgs = {inherit inputs system userVars host;};
  modules = [./configuration.nix];
}
