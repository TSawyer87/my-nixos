{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.gytix.cachix;
in {
  options = {
    gytix.cachix.enable = mkEnableOption "Enable custom cachix configuration";
  };

  config = mkIf cfg.enable {
    #environment.systemPackages = with pkgs; [ cachix ];

    nix.extraOptions = "gc-keep-outputs = true";
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://ghostty.cachix.org"
        "https://neovim-nightly.cachix.org"
        "https://nushell-nightly.cachix.org"
      ];
      trusted-public-keys = [
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "neovim-nightly.cachix.org-1:feIoInHRevVEplgdZvQDjhp11kYASYCE2NGY9hNrwxY="
        "nushell-nightly.cachix.org-1:nLwXJzwwVmQ+fLKD6aH6rWDoTC73ry1ahMX9lU87nrc="
      ];
    };
  };
}
