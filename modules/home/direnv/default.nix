{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = { load_dotenv = true; };
      whitelist = { prefix = [ "~/Code/" ]; };
    };
    stdlib = ''
      function use_op() {
        if [[ $# -ne 2 ]]; then
          echo "invalid arguments for use_op"
        fi

        export "$1=$(op read "$2")"
      }
    '';
  };
}

