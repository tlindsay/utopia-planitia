{
  user,
  config,
  pkgs,
  ...
}: let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
  kitty_icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/igrmk/whiskers/main/whiskers.icns";
    sha256 = "c5bff113eac01b0074cc862eca3380e3ceb835d28a43f207aa77a9820be3262e";
  };
  direnv_oprc = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/venkytv/direnv-op/main/oprc.sh";
    sha256 = "TTkxSodOqC4gR/5eGfMa1te7Dli3sTQVGDCO30DXHgE=";
  };
in {
  "darwin.txt" = {
    text = ''
      hi, ${user}! this is from darwin/files.nix
       your hostname is ${config.networking.hostName}'';
  };
  ".default-golang-pkgs" = {
    text = (builtins.readFile ../dotfiles/default-golang-pkgs);
  };
  "${xdg_configHome}/kitty/kitty.app.icns".source = kitty_icon;
  "${xdg_configHome}/direnv/lib/oprc.sh".source = direnv_oprc;
}
