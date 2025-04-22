{
  description = "Minimal NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    wallpapers = {
      url = "git+ssh://git@github.com/TSawyer87/wallpapers.git";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";
    host = "magic";
    username = "jr";
    userVars = {
      gitEmail = "sawyerjr.25@gmail.com";
      gitUsername = "TSawyer87";
      editor = "hx";
      term = "ghostty";
      keys = "us";
      browser = "firefox";
      flake = "/home/jr/my-nixos";
    };

    # Define pkgs with allowUnfree
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Use nixpkgs.lib directly
    lib = nixpkgs.lib;

    # Formatter configuration
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;

    # REPL function for debugging
    repl = import ./repl.nix {
      inherit pkgs lib;
      flake = self;
    };
  in {
    # Formatter for nix fmt
    formatter.${system} = treefmtEval.config.build.wrapper;

    # Style check for CI
    checks.${system}.style = treefmtEval.config.build.check self;

    # Development shell
    devShells.${system}.default = import ./lib/dev-shell.nix {
      inherit inputs pkgs;
    };

    # Default package for tools
    packages.${system}.default = pkgs.buildEnv {
      name = "default-tools";
      paths = with pkgs; [helix git ripgrep nh];
    };

    # Custom outputs in legacyPackages
    legacyPackages.${system} = {
      inherit userVars repl;
    };

    # NixOS configuration
    nixosConfigurations.${host} = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs username system host userVars pkgs lib;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./hosts/${host}/home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit inputs username system host userVars pkgs lib;
          };
        }
      ];
    };
  };
}
