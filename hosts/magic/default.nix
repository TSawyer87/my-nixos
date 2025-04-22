{inputs, ...}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system host userVars;
  specialArgs = {inherit inputs;};
  modules = [./configuration.nix];
}
