{
  inputs,
  userVars,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system host;
  specialArgs = {inherit inputs userVars;};
  modules = [./configuration.nix];
}
