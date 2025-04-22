{
  # userVars,
  pkgs,
  ...
}: {
  home.file.".jj/config.toml".text = ''
    [ui]
    diff-editor = ["nvim", "-c", "DiffEditor $left $right $output"]
  '';
  home.packages = with pkgs; [
    lazyjj
    meld
  ];
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "sawyerjr.25@gmail.com";
          name = "TSawyer87";
        };
        ui = {
          default-command = [
            "status"
            "--no-pager"
          ];
          diff-editor = ":builtin";
          merge-editor = ":builtin";
        };
      };
    };
  };
}
