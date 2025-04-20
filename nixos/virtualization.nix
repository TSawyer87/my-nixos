# Virtualization / Containers
_: {
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = false;
  };
  programs.virt-manager.enable = true;
}
