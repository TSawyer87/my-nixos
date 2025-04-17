{inputs, ...}:
inputs.hydenix-nixpkgs.lib.nixosSystem {
  inherit (inputs.lib) system;
  specialArgs = {
    inherit inputs;
  };
  modules = [
    ./configuration.nix
  ];
}
