{
  pkgs,
  userVars,
  inputs,
  ...
}: {
  # Home Manager Settings
  home = {
    username = userVars.username;
    homeDirectory = "/home/" + userVars.username;
    stateVersion = "24.11";
  };

  # Import Program Configurations
  imports = [
    ../../home
    inputs.dont-track-me.homeManagerModules.default
  ];

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  home.packages = with pkgs; [
    libnotify
    ventoy
    gdb # Nix Debugger
  ];

  # Enable auto-mount
  services.udiskie.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Styling Options
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    wofi.enable = false;
    mako.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    helix.enable = false;
    # ghostty.enable = false
    # zed.enable = false
    # nvf.enable = false
  };
}
