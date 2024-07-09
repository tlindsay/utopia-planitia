{
  config,
  pkgs,
  lib,
  user,
  inputs,
  ...
}: let
  plugins =
    pkgs.tmuxPlugins
    // pkgs.callPackage ./custom-plugins.nix {inherit lib pkgs inputs;};
in {
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;

    prefix = "C-s";
    keyMode = "vi";
    escapeTime = 10;
    historyLimit = 5000;
    secureSocket = true;

    baseIndex = 0;

    mouse = true;

    extraConfig = ''
      # Fix undercurls, RGB, etc.
      # https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
      set-env -g TERMINFO_DIRS ${pkgs.ncurses}/share/terminfo:/Applications/Ghostty.app/Contents/Resources/terminfo:$TERMINFO_DIRS

      if-shell 'infocmp tmux-256color' { set default-terminal tmux-256color } { set default-terminal screen-256color }

      # Enable RGB (truecolor)
      set -ga terminal-features '*:RGB'

      # Enable colored underlines (e.g. in Vim)
      set -ga terminal-features '*:usstyle'

      # set -ga terminal-features '*ghostty*:hyperlinks'
      # set -ga terminal-features '*ghostty*:overline'
      # set -ga terminal-features '*ghostty*:RGB'
      # set -ga terminal-features '*ghostty*:sixel'
      # set -ga terminal-features '*ghostty*:strikethrough'
      # set -ga terminal-features '*ghostty*:usstyle'

      # Use extended keys (CSI u)
      set extended-keys on

      # Enable focus events
      set focus-events on

      # Allow tmux to set the title of the terminal emulator
      set -g set-titles on
      set -g set-titles-string '#T #{session_alerts}'

      # Automatically update tab numbers when re-arranging
      set -g renumber-windows on

      # # Using `default-command $SHELL` with `default-shell /bin/sh` will cause new
      # # tmux windows to be spawned using
      # #
      # #       /bin/sh -c $SHELL
      # #
      # # This ensures that new windows are created as non-login interactive shells
      # set -g default-shell /bin/sh
      # if-shell 'command -v zsh' { set -g default-command zsh } { set -g default-command $SHELL }

      #############################
      ### CUSTOM KEYMAPS
      #############################

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"
      # bind C-s split-window -v "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
      # bind C-s display-popup -E  "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

      #############################
      ### STYLING, PROFILING
      #############################

      # Vertical Separator Char: "▍"
      set-option -g status-position top
      set -g status-fg black
      set -g status-bg brightmagenta
      set -g status-left "#[fg=black,bg=green,bold] #S "
      set -g status-left-length 100
      set -g status-right-length 140
      set -g status-right ""
      set -ag status-right "#[reverse,blink]#{?pane_synchronized,#{@prefix_highlight_sync_prompt},}#[default]"
      # set -ag status-right "#[bold]#{prefix_highlight}"
      set -ag status-right "#[bold,fg=#{@prefix_highlight_fg},bg=#{@prefix_highlight_bg}]#{?client_prefix, #{@prefix_highlight_prefix_prompt},#{@prefix_highlight_empty_prompt}}"
      set -ag status-right "#[fg=black,bg=green,nobold]#(now-playing)"
      set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
      set -ag status-right "#[fg=black,bg=cyan]#(check-vpn && echo '󰌘 ' || echo '󰌙 ') #(ifconfig en0 inet | grep 'inet ' | awk '{print $2}') "
      set -ag status-right "#[fg=brightmagenta,bg=cyan]▍"
      set -ag status-right "#[fg=black]%a %m/%d %l:%M %p "

      setw -g window-status-format "#[fg=black,bg=brightmagenta] #I: #W "
      setw -g window-status-current-format "#[fg=cyan,bg=black] #I: #W "

      set -g clock-mode-style 12

      set -g pane-border-status off
      set -g pane-border-status bottom
      set -g pane-border-format ""
      set -g pane-border-style fg=magenta
      set -g pane-active-border-style fg=cyan

      set -g monitor-activity on
      set -g window-status-activity-style bg=red,fg=white
      set -g window-status-bell-style bg=default,fg=red,blink

      set -g popup-border-lines rounded


      #############################
      ### SMART SPLITS
      #############################

      ###### The following config comes from https://github.com/mrjones2014/smart-splits.nvim#tmux
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?|fzf|gum)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 10'
      bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 5'
      bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 5'
      bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 10'

      bind-key -n M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 2'
      bind-key -n M-J if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 2'
      bind-key -n M-K if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 2'
      bind-key -n M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 2'

      bind-key -n PgUp if-shell "$is_vim" 'send-keys PgUp' 'copy-mode; send-keys -X halfpage-up'
      bind-key -n PgDn if-shell "$is_vim" 'send-keys PgDn' 'copy-mode; send-keys -X halfpage-down'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      bind-key -n M-> 'swap-window -t +1; select-window -t +1'
      bind-key -n M-< 'swap-window -t -1; select-window -t -1'

      ### WINDOW/PANE MANAGEMENT
      #############################
      bind - split-window -v -c '#{pane_current_path}'
      bind \\ split-window -h -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      bind b break-pane -d

      bind d kill-pane
      bind X kill-window
      bind = setw synchronize-panes

      ### MOUSE/COPY MODE
      #############################

      # https://github.com/tmux/tmux/issues/140
      # disable "release mouse drag to copy and exit copy-mode", ref: https://github.com/tmux/tmux/issues/140
      unbind-key -T copy-mode-vi MouseDragEnd1Pane

      # since MouseDragEnd1Pane neither exit copy-mode nor clear selection now,
      # let single click do selection clearing for us.
      bind-key -T copy-mode-vi MouseDown1Pane select-pane\; send-keys -X clear-selection

      # Setup 'v' to begin selection as in Vim
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"

      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"
    '';

    plugins = [
      {
        plugin = plugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-save 'S'
          set -g @resurrect-restore 'R'
        '';
      }
      {
        plugin = plugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg 'pink'
          set -g @prefix_highlight_bg 'black'
          # set -g @prefix_highlight_empty_prompt '󰵟 '
          set -g @prefix_highlight_copy_prompt ' '
          set -g @prefix_highlight_prefix_prompt '󰽀 '
          set -g @prefix_highlight_sync_prompt ' 󱎡 '
          set -g @prefix_highlight_show_sync_mode 'on'
        '';
      }
      {plugin = plugins.better-mouse-mode;}
      plugins.cowboy
      {
        plugin = plugins.tmux-menus;
        extraConfig = ''
          unbind-key -n MouseDown3Pane
          unbind-key -n M-MouseDown3Pane
          unbind-key -n MouseDown3Status
          unbind-key -n MouseDown3StatusLeft
          unbind-key <
          unbind-key >
          set -g @menus_trigger 'C-m'
        '';
      }
      {
        plugin = plugins.session-wizard;
        extraConfig = ''
          set -g @session-wizard 'C-s'
        '';
      }
      plugins.open-nvim
      {
        plugin = plugins.fingers;
        extraConfig = ''
          # Overrides matching file paths with :[line]:[col] at the end
          set -g @fingers-pattern-0 "((^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]+)(:[[:digit:]]*:[[:digit:]]*)?"

          # Launches helper script on Ctrl+[key] in fingers mode
          set -g @fingers-ctrl-action "xargs -I {} tmux run-shell 'cd #{pane_current_path}; ~/.tmux/plugins/tmux-open-nvim/scripts/ton {} > ~/.tmux/plugins/tmux-open-nvim/ton.log'"s
        '';
      }
    ];
  };
}
