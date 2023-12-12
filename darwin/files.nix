{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state";
  dotfiles = pkgs.fetchFromGitHub {
    owner = "tlindsay";
    repo = "dotfiles";
    rev = "b0b41900d1385175ed594c3eb9a5c14842ddcb8b";
    sha256 = null;
  };
  in
{
  "darwin.txt" = {
    text = "hi, ${user}! this is from darwin/files.nix";
  };
}
