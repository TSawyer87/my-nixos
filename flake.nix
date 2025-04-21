{
  description = "NixOS/Home-Manager Flake";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    dont-track-me.url = "github:dtomvan/dont-track-me.nix/main";
    stylix.url = "github:danth/stylix";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";
    wezterm.url = "github:wezterm/wezterm?dir=nix";
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
    host = "magic";
    username = "jr";
    system = "x86_64-linux";
    userVars = {
      gitEmail = "sawyerjr.25@gmail.com";
      gitUsername = "TSawyer87";
      editor = "hx";
      term = "ghostty";
      keys = "us";
      browser = "firefox";
      flake = "/home/jr/my-nixos";
    };

    my-inputs =
      inputs
      // {
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
        lib = {
          nixOsModules = import ./nixos;
          homeModules = import ./home;
          inherit system;
        };
      };
    defaultConfig = import ./hosts/${host} {
      inherit my-inputs;
    };
    # vmConfig = import ./lib/vms/nixos-vm.nix {
    #   nixosConfiguration = defaultConfig;
    #   inherit my-inputs;
    # };
    # pkgs = import nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    # };

    treefmtEval = treefmt-nix.lib.evalModule my-inputs.pkgs ./lib/treefmt.nix;
  in {
    lib = my-inputs.lib;

    checks.${system}.style = treefmtEval.config.build.check self;

    formatter.${system} = treefmtEval.config.build.wrapper;

    devShells.${system}.default = import ./lib/dev-shell.nix {inherit inputs;};

    # repl = import ./repl.nix {
    #   inherit (pkgs) lib;
    #   flake = self;
    #   inherit pkgs;
    # };
    # inherit userVars;

    packages.${system} = {
      default = pkgs.buildEnv {
        name = "default-tools";
        paths = with pkgs; [
          helix
          git
          ripgrep
          nh
        ];
      };
      nixos = defaultConfig.config.system.build.toplevel;
      # Explicitly named VM configuration
      # nixos-vm = vmConfig.config.system.build.vm;
    };

    nixosConfigurations = {
      ${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            username
            system
            host
            userVars
            ;
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
              inherit
                inputs
                username
                system
                host
                userVars
                ;
            };
          }
        ];
      };
    };
  };
}
