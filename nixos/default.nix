{...}: {
  imports = [
    ./drivers
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./hardware.nix
    ./nix.nix
    ./xdg.nix
    ./zram.nix
    ./stylix.nix
    ./fonts.nix
    ./i18n.nix
    ./environmentVariables.nix
    ./greetd.nix
    ./cachix.nix
    ./pipewire.nix
    ./programs.nix
    ./keyd.nix
    ./thunar.nix
    ./lsp.nix
  ];
}
