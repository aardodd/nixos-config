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
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = name;
    userEmail = email;
    delta.enable = true;
    extraConfig = {
      commit.gpgSign = true;
      commit.template = "${commitTemplate}";
      feature.manyFiles = true;
      format.signoff = true;
      gpg.ssh.allowedSignersFile = "/home/aaron/.config/git/allowed_signers";
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = "true";
      push.default = "current";
      tag.gpgSign = true;
      user.signingkey = "/home/aaron/.ssh/id_ed25519.pub";
    };
    ignores = [ ".direnv" "result" ];
  };
}
