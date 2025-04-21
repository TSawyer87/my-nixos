{
  inputs,
  lib,
  ...
}: {
  nix = {
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Number of simultaneous derivation builds
      max-jobs = lib.mkDefault "auto";

      # Number of cores per derivation build
      cores = lib.mkDefault 0; # 0 means "use all available cores"
    };
    registry = {
      # self = this flake
      self.flake = inputs.self;
      # nixpkgs.flake = inputs.nixpkgs;
    };
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 4d";
    # };
  };
}
