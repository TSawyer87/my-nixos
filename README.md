### Debugging with a Flake REPL output

- One way to do this is to launch the repl with `nix repl` and inside the repl type `:lf /path/to/flake`. Or `nixos-rebuild repl --flake /path/to/flake` the latter provides a helpful welcome script showing what is loaded into your repl's scope.

  First, we'll create a REPL environment to inspect and debug our flake's outputs,packages, and configurations. Define a `repl` output in `flake.nix` for easy access with `nix repl .#repl`:

```nix
# flake.nix
outputs = { self, nixpkgs, ... }: let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
in {
  repl = import ./repl.nix {
    inherit (pkgs) lib;
    flake = self;
    pkgs = pkgs;
  };
};
```

And in `repl.nix`:

```nix
# repl.nix
{
  lib,
  flake,
  pkgs,
}: {
  inherit flake pkgs lib;
  configs = flake.nixosConfigurations;
}
```

## Usage

Load REPL environment with:
`nix repl .#repl`

Attributes:

```nix
nix-repl> builtins.attrNames flake.inputs
[
  "dont-track-me"
  "helix"
  "home-manager"
  "hyprland"
  "neovim-nightly-overlay"
  "nixpkgs"
  "nvf"
  "rose-pine-hyprcursor"
  "stylix"
  "treefmt-nix"
  "wallpapers"
  "wezterm"
  "yazi"
]
nix-repl> builtins.attrNames flake.outputs
[
  "checks"
  "devShells"
  "formatter"
  "nixosConfigurations"
  "packages"
  "repl"
]
nix-repl> flake.outputs.formatter
{
  x86_64-linux = «derivation /nix/store/q71q00wmh1gnjzdrw5nrvwbr6k414036-treefmt.drv»;
}
```

- Inspect the default package output:

```nix
nix-repl> flake.outputs.packages.x86_64-linux.default
«derivation /nix/store/6kp660mm62saryskpa1f2p6zwfalcx2w-default-tools.drv»
```

- From here out I'll leave out the `nix-repl>` prefix just know that it's there.

- Check lib version(Nixpkgs `lib` attribute):

```nix
lib.version
"25.05pre-git"
```

- List systemPackages and home.packages, my hostname is `magic` list yours in its place:

```nix
configs.magic.config.environment.systemPackages
# list home.packages
configs.magic.config.home-manager.users.jr.home.packages
```

- Or an individual value:

```nix
:p configs.magic.config.home-manager.users.jr.programs.git.userName
TSawyer87
```

### Debugging

- Check if the module system is fully evaluating, anything other than a "set" the configuration isn't fully evaluated (e.g. "lambda" might indicate an unevaluated thunk):

```nix
:p builtins.typeOf configs.magic
set
```

- Debugging Module System:

- Check if `configs.magic` is a valid configuration:

```nix
:p builtins.attrNames configs.magic
```
