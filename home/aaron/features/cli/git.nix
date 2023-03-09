{ pkgs, ... }:
let
  name = "Aaron Dodd";
  email = "contact@aaronrdodd.com";
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
      commit.gpgSign = true;
      feature.manyFiles = true;
      format.signoff = true;
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = "true";
      push.default = "current";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
    ignores = [ ".direnv" "result" ];
  };
}
