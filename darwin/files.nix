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
in {
  "darwin.txt" = {
    text = "hi, ${user}! this is from darwin/files.nix\n your hostname is ${config.networking.hostName}";
  };
  "${xdg_configHome}/kitty/kitty.app.icns".source = kitty_icon;
}
