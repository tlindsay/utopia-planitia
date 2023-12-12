{ config, pkgs, lib, user, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night Moon";
    shellIntegration.enableZshIntegration = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = ["FantasqueSansMono"]; });
      name = "FantasqueSansM Nerd Font";
      size = 20.0;
    };
    keybindings = {
      "cmd+enter" = "toggle_fullscreen";
    };
    settings = {
      disable_ligatures = "cursor";
      detect_urls = "yes";
      editor = "nvim";
      hide_window_decorations = true;
      macos_custom_beam_cursor = true;
      macos_option_as_alt = true;
      macos_thicken_font = "0.25";
      macos_traditional_fullscreen = true;
      term = "xterm-kitty";
    };
    extraConfig = ''
      font_features FantasqueSansMNerdFont-Regular -liga +calt

      modify_font underline_position 0
      modify_font underline_thickness 100%
      modify_font cell_height -2px
      modify_font baseline 2

      mouse_map left click grabbed,ungrabbed mouse_handle_click selection link promp
    '';
  };
}
