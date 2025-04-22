{
  pkgs,
  host,
  userVars,
  ...
}: {
  home.packages = [
    # inputs.zen-browser.packages."${pkgs.system}".default
    pkgs.Tela-circle-dracula
    pkgs.oh-my-zsh
    pkgs.just
    pkgs.fzf
    pkgs.glow # markdown previewer in terminal
    pkgs.iotop # io monitoring
    pkgs.iftop # network monitoring
    pkgs.usbutils # lsusb
    pkgs.nitch
    pkgs.nix-fast-build
    (import ../scripts/emopicker9000.nix {inherit pkgs;})
    (import ../scripts/task-waybar.nix {inherit pkgs;})
    (import ../scripts/squirtle.nix {inherit pkgs;})
    (import ../scripts/wallsetter.nix {
      inherit pkgs;
      inherit userVars;
    })
    (import ../scripts/web-search.nix {inherit pkgs;})
    (import ../scripts/rofi-launcher.nix {inherit pkgs;})
    (import ../scripts/screenshootin.nix {inherit pkgs;})
    (import ../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];
}
