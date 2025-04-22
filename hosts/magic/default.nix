{
  inputs,
  userVars,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system;
  specialArgs = {inherit inputs userVars;};
  modules = [./configuration.nix];
}
