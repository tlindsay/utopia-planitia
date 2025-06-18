{
  pkgs,
  namespace,
  ...
}: {
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
      # 5/20/25: Disabling to fix pasting within nvim
      # https://github.com/ghostty-org/ghostty/discussions/5924
      set -ga terminal-features 'xterm*:extkeys'
      set extended-keys on
      set-option -g extended-keys on

      # Enable focus events
      set focus-events on
      set-option -g focus-events on

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
      bind C display-popup -T "Choose directory:" -E "zoxide query -i | xargs tmux new-window -c"
      # bind C-s split-window -v "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
      # bind C-s display-popup -E  "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

      #############################
      ### STYLING, PROFILING
      #############################

      set -g popup-border-lines rounded

      #############################
      ### SMART SPLITS
      #############################

      ###### The following config comes from https://github.com/mrjones2014/smart-splits.nvim#tmux
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(n?vim?x?)(diff)?$'"
      is_tui="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(view|fzf|gum|atuin)$'"
      bind-key -n -N "select-pane LEFT"  C-h if-shell "$is_vim"            'send-keys C-h' 'select-pane -L'
      bind-key -n -N "select-pane DOWN"  C-j if-shell "$is_vim || $is_tui" 'send-keys C-j' 'select-pane -D'
      bind-key -n -N "select-pane UP"    C-k if-shell "$is_vim || $is_tui" 'send-keys C-k' 'select-pane -U'
      bind-key -n -N "select-pane RIGHT" C-l if-shell "$is_vim"            'send-keys C-l' 'select-pane -R'

      bind-key -n -N "resize-pane LEFT 10"  M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 10'
      bind-key -n -N "resize-pane DOWN 5"   M-j if-shell "$is_vim || $is_tui" 'send-keys M-j' 'resize-pane -D 5'
      bind-key -n -N "resize-pane UP 5"     M-k if-shell "$is_vim || $is_tui" 'send-keys M-k' 'resize-pane -U 5'
      bind-key -n -N "resize-pane RIGHT 10" M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 10'

      bind-key -n -N "resize-pane LEFT 2"  M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 2'
      bind-key -n -N "resize-pane DOWN 2"  M-J if-shell "$is_vim || $is_tui" 'send-keys M-J' 'resize-pane -D 2'
      bind-key -n -N "resize-pane UP 2"    M-K if-shell "$is_vim || $is_tui" 'send-keys M-K' 'resize-pane -U 2'
      bind-key -n -N "resize-pane RIGHT 2" M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 2'

      bind-key -n PgUp if-shell "$is_vim || $is_tui" 'send-keys PgUp' 'copy-mode -e; send-keys -X halfpage-up'
      bind-key -n PgDn if-shell "$is_vim || $is_tui" 'send-keys PgDn' 'copy-mode -e; send-keys -X halfpage-down'

      bind-key -N "Force select-pane LEFT"  C-h 'select-pane -L'
      bind-key -N "Force select-pane DOWN"  C-j 'select-pane -D'
      bind-key -N "Force select-pane UP"    C-k 'select-pane -U'
      bind-key -N "Force select-pane RIGHT" C-l 'select-pane -R'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      # bind-key y copy-mode;
      #   send-keys -X previous-prompt;
      #   send-keys -X previous-prompt;
      #   send-keys -X -N 1 cursor-down;
      #   send-keys -X start-of-line;
      #   send-keys -X next-word;
      #   send-keys -X begin-selection;
      #   send-keys -X next-prompt;
      #   send-keys -X -N 1 cursor-up;
      #   send-keys -X end-of-line;
      #   send-keys -X copy-pipe-and-cancel 'sed "1s/^.*?\K\s+󰅐 (\d{1,2}:?){3}$//" | xargs echo "$" | reattach-to-user-namespace pbcopy'
      bind-key y copy-mode \; send-keys -X previous-prompt \; send-keys -X previous-prompt \; send-keys -X -N 1 cursor-down \; send-keys -X start-of-line \; send-keys -X next-word \; send-keys -X begin-selection \; send-keys -X next-prompt \; send-keys -X -N 1 cursor-up \; send-keys -X end-of-line \; send-keys -X copy-pipe-and-cancel 'sed "1s/^.*?\K\s+󰅐 (\d{1,2}:?){3}$//" | xargs echo "$" | reattach-to-user-namespace pbcopy'

      # bind-key Y copy-mode
      #   send-keys -X previous-prompt -o;
      #   send-keys -X begin-selection;
      #   send-keys -X next-prompt;
      #   send-keys -X -N 1 cursor-up;
      #   send-keys -X end-of-line;
      #   send-keys -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
      bind-key Y copy-mode \; send-keys -X previous-prompt -o \; send-keys -X begin-selection \; send-keys -X next-prompt \; send-keys -X -N 1 cursor-up \; send-keys -X end-of-line \; send-keys -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'

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
      bind-key -T copy-mode-vi Y send-keys -X copy-pipe-end-of-line "reattach-to-user-namespace pbcopy"

      bind-key -T copy-mode-vi [ send-keys -X previous-prompt
      bind-key -T copy-mode-vi ] send-keys -X next-prompt

      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe "reattach-to-user-namespace pbcopy"
    '';

    plugins = [
      {
        plugin = pkgs."${namespace}".tokyo-night-tmux;
        extraConfig = ''
          set -g status-left-length 100
          set -g status-right-length 140

          set -g @tokyo-night-tmux_theme moon

          set -g @tokyo-night-tmux_window_id_style digital
          set -g @tokyo-night-tmux_pane_id_style hsquare
          set -g @tokyo-night-tmux_zoom_id_style dsquare

          set -g @tokyo-night-tmux_show_datetime 1
          set -g @tokyo-night-tmux_date_format MDY
          set -g @tokyo-night-tmux_time_format 12H

          set -g @tokyo-night-tmux_show_music 1
          set -g @tokyo-night-tmux_show_music__artist 1
          set -g @tokyo-night-tmux_show_music__time 0

          set -g @tokyo-night-tmux_show_path 1
          set -g @tokyo-night-tmux_path_format relative     # 'relative' or 'full'

          set -g @tokyo-night-tmux_show_netspeed 0
          # set -g @tokyo-night-tmux_show_netspeed 1
          set -g @tokyo-night-tmux_netspeed_iface "en0"     # Detected via default route
          set -g @tokyo-night-tmux_netspeed_showip 0        # Display IPv4 address (default 0)
          set -g @tokyo-night-tmux_netspeed_refresh 1       # Update interval in seconds (default 1)

          set -g @tokyo-night-tmux_show_git 0
          # set -g @tokyo-night-tmux_show_git 1
          set -g @tokyo-night-tmux_show_wbg 0

          set -g @tokyo-night-tmux_show_path 0
          set -g @tokyo-night-tmux_path_format relative     # 'relative' or 'full'

          set -g @tokyo-night-tmux_show_battery_widget 0
          set -g @tokyo-night-tmux_battery_low_threshold 51 # default
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-save 'S'
          set -g @resurrect-restore 'R'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.prefix-highlight;
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
      {plugin = pkgs.tmuxPlugins.better-mouse-mode;}
      pkgs."${namespace}".tmux-cowboy
      {
        plugin = pkgs."${namespace}".tmux-menus;
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
        plugin = pkgs.tmuxPlugins.tmux-fzf;
        # extraConfig = ''
        #   set-env TMUX_FZF_LAUNCH_KEY "C-s"
        # '';
      }
      {
        plugin = pkgs."${namespace}".tmux-open-nvim;
        extraConfig = ''
          set -g @ton-open-strategy ":tabnew"
          set -g @ton-prioritize-window true
          set -g @open-strategy ":tabnew"
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.fingers;
        extraConfig = ''
          # Overrides matching file paths with :[line]:[col] at the end
          set -g @fingers-pattern-0 "((^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]+)(:[[:digit:]]*:[[:digit:]]*)?"

          set -g @fingers-ctrl-action ":open:"
        '';
      }
    ];
  };
}
