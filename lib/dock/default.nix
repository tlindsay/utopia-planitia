{lib, ...}: {
  dock = pkgs: config: let
    cfg = config.local.dock;
    inherit (pkgs) stdenv dockutil;
  in {
    options = {
      local.dock.enable = lib.mkOption {
        description = "Enable dock";
        default = stdenv.isDarwin;
        example = false;
      };

      local.dock.entries = lib.mkOption {
        description = "Entries on the Dock";
        type = with lib.types;
          listOf (submodule {
            options = {
              path = lib.mkOption {type = str;};
              section = lib.mkOption {
                type = str;
                default = "apps";
              };
              options = lib.mkOption {
                type = str;
                default = "";
              };
            };
          });
        readOnly = true;
      };
    };

    config = lib.mkIf cfg.enable (let
      normalize = path:
        if lib.hasSuffix ".app" path
        then path + "/"
        else path;
      entryURI = path:
        "file://"
        + (builtins.replaceStrings [
            " "
            "!"
            ''"''
            "#"
            "$"
            "%"
            "&"
            "'"
            "("
            ")"
          ] ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
          (normalize path));
      wantURIs =
        lib.concatMapStrings (entry: ''
          ${entryURI entry.path}
        '')
        cfg.entries;
      createEntries =
        lib.concatMapStrings (entry: ''
          ${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}
        '')
        cfg.entries;
    in {
      system.activationScripts.postUserActivation.text = ''
        echo >&2 "Setting up the Dock..."
        haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
        if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
          echo >&2 "Resetting Dock."
          ${dockutil}/bin/dockutil --no-restart --remove all
          ${createEntries}
          killall Dock
        else
          echo >&2 "Dock setup complete."
        fi
      '';
    });
  };
}
