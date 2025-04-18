{
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    statix.enable = true;
    # shellcheck.enable = true;
    # rustmft.enable = true;
    # prettier.enable = true;
    keep-sorted.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
  };
  settings.excludes = [
    "*.age"
    "*.jpg"
    "*.nu"
    "*.png"
    ".jj/*"
    "flake.lock"
    "hive/moonrise/borg-key-backup"
    "justfile"
  ];

  formatter = {
    deadnix = {
      priority = 1;
    };

    statix = {
      priority = 2;
    };

    nixfmt = {
      priority = 3;
    };

    # prettier = {
    #   options = [
    #     "--tab-width"
    #     "4"
    #   ];
    #   includes = [
    #     "*.css"
    #     "*.html"
    #     "*.js"
    #     "*.json"
    #     "*.jsx"
    #     "*.md"
    #     "*.mdx"
    #     "*.scss"
    #     "*.ts"
    #     "*.yaml"
    #   ];
    # };
  };
}
