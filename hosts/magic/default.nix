{
  inputs,
  userVars,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system userVars;
  specialArgs = {inherit inputs userVars;};
  modules = [./configuration.nix];
}
