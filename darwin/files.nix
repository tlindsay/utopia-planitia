{
  user,
  config,
  pkgs,
  ...
}: let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
  direnv_oprc = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/venkytv/direnv-op/main/oprc.sh";
    sha256 = "TTkxSodOqC4gR/5eGfMa1te7Dli3sTQVGDCO30DXHgE=";
  };
in {
  ".default-golang-pkgs" = {
    text = (builtins.readFile ../dotfiles/default-golang-pkgs);
  };
  "${xdg_configHome}/direnv/lib/oprc.sh".source = direnv_oprc;
}
