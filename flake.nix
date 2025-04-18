{
  description = "NixOS/Home-Manager Flake";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://yazi.cachix.org"
      "https://helix.cachix.org"
      "https://wezterm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
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
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;
  in {
    checks.x86_64-linux.style = treefmtEval.config.build.check self;

    formatter.x86_64-linux = treefmtEval.config.build.wrapper;

    devShells.${system}.default = import ./lib/dev-shell.nix {inherit inputs;};

    packages.x86_64-linux.default = pkgs.buildEnv {
      name = "default-tools";
      paths = with pkgs; [
        helix
        git
        ripgrep
        nh
      ];
    };

    # nixosModules = import ./nixos;

    # homeManagerModules = import ./home;

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
