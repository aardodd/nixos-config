{ pkgs, ... }:
let
  name = "Aaron Dodd";
  email = "8947937+aardodd@users.noreply.github.com";
  commitTemplate = pkgs.writeTextFile {
    name = "aaron-commit-template";
    text = ''
      Signed-off-by: ${name} <${email}>
    '';
  };
in {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = name;
    userEmail = email;
    delta.enable = true;
    extraConfig = {
      commit.template = "${commitTemplate}";
      feature.manyFiles = true;
      format.signoff = true;
      init.defaultBranch = "main";
      pull.rebase = "true";
      push.default = "current";
    };
    ignores = [ ".direnv" "result" ];
  };
}
