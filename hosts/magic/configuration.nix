{userVars, ...}: {
  imports = [
    ./hardware.nix
    ./security.nix
    ./users.nix
    ../../nixos
  ];

  # Enable or Disable Stylix
  stylixModule.enable = true;

  # Enable User module
  users.enable = true;
  users = {mutableUsers = true;};

  # Custom Cachix enable
  gytix.cachix.enable = true;

  # Custom amd module
  drivers.amdgpu.enable = true;

  # vm.guest-services.enable = false;
  # local.hardware-clock.enable = true;

  # Enable Impermanence
  # isEphemeral = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  console.keyMap = userVars.keys;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
