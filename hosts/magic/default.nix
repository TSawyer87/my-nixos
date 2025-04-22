{inputs, ...}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system userVars;
  specialArgs = {inherit inputs;};
  modules = [./configuration.nix];
}
