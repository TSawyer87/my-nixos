{
  description = "NixOS/Home-Manager Flake";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
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
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;
  in {
    checks.${system}.style = treefmtEval.config.build.check self;

    formatter.${system} = treefmtEval.config.build.wrapper;

    devShells.${system}.default = import ./lib/dev-shell.nix {inherit inputs;};

    packages.${system}.default = pkgs.buildEnv {
      name = "default-tools";
      paths = with pkgs; [
        helix
        git
        ripgrep
        nh
      ];
    };

    # Linting check with deadnix
    # deadnixCheck = pkgs.runCommand "deadnix-check" {nativeBuildInputs = [pkgs.deadnix];} ''
    #   deadnix --fail ${self}
    #   touch $out
    # '';

    # nixosConfig = self.nixosConfigurations.${host}.config.system.build.toplevel;

    # depInject = {
    #   pkgs,
    #   lib,
    #   ...
    # }: {
    #   options.dep-inject = lib.mkOption {
    #     type = with lib.types; attrsOf unspecified;
    #     default = {};
    #   };
    #   config.dep-inject = {
    #     # inputs comes from the outer environment of flake.nix
    #     flake-inputs = inputs;
    #     userVars = userVars;
    #   };
    # };

    # packages.x86_64-linux.helloNixosTests = pkgs.writeScriptBin "hello-nixos-tests" ''
    #   ${pkgs.netcat}/bin/nc -l 3000
    # '';

    # nixosModules.default = {
    #   pkgs,
    #   lib,
    #   ...
    # }: {
    #   imports = [depInject];
    # };

    # nixosModules = import ./nixos;

    nixosTests.testConfig = nixpkgs.nixosTest {
      name = "test-config";
      nodes = {
        testVM = {pkgs, ...}: {
          imports = [
            ./hosts/magic/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };
      };
      testScript = ''
        start_all()
        testVM.wait_for_unit("network.target")
        testVM.wait_for_unit("multi-user.target")
        assert testVM.systemctl.is_active("network.target")
      '';
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
          # self.nixosModules.default
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
