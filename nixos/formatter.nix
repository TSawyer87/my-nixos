{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt = {
      projectRootFile = ".git/config";

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        gofumpt.enable = true;
        prettier.enable = true;
        rustfmt.enable = true;
        shellcheck.enable = true;
        statix.enable = true;
      };

      settings = {
        global.excludes = [
          "LICENSE"
          ".adr-dir"
          # unsupported extensions
          "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,gitignore,sql,conf,pem,*.so.2,key,pub,py,narHash}"
          "data-mesher/test/networks/*"
          "nss-datamesher/test/dns.json"
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

          prettier = {
            options = [
              "--tab-width"
              "4"
            ];
            includes = ["*.{css,html,js,json,jsx,md,mdx,scss,ts,yaml}"];
          };
        };
      };
    };
  };
}
