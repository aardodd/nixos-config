{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Aaron Dodd";
    userEmail = "8947937+aardodd@users.noreply.github.com";
    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
    };
    ignores = [ ".direnv" "result" ];
  };
}
