{my-inputs, ...}:
my-inputs.nixpkgs.lib.nixosSystem {
  inherit (my-inputs.lib) system;
  specialArgs = {inherit my-inputs;};
  modules = [./configuration.nix];
}
