_final: prev: let
  # Helper function to import a package
  callPackage = prev.lib.callPackageWith (prev // packages);

  # Define all packages
  packages = {
    # Additional packages
    pokego = callPackage ./pokego.nix {};
    pokemon-colorscripts = callPackage ./pokemon-colorscripts.nix {};
    python-pyamdgpuinfo = callPackage ./python-pyamdgpuinfo.nix {};
    Tela-circle-dracula = callPackage ./Tela-circle-dracula.nix {};
    Bibata-Modern-Ice = callPackage ./Bibata-Modern-Ice.nix {};
  };
in
  packages
