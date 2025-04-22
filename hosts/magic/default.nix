{
  inputs,
  userVars,
  host,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system;
  specialArgs = {inherit inputs userVars host;};
  modules = [./configuration.nix];
}
