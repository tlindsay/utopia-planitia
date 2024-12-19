{
  programs.k9s = {
    enable = true;
    settings = { k9s = { liveViewAutoRefresh = true; }; };
    plugin = {
      plugins = {
        # Sends logs over to jq for processing. This leverages kubectl plugin kubectl-jq.
        jqlogs = {
          shortCut = "Shift-J";
          confirm = false;
          description = "Logs (jq)";
          scopes = [ "container" ];
          background = false;
          command = "sh";
          args = [
            "-c"
            "kubectl logs -f $POD -c $NAME -n $NAMESPACE --context $CONTEXT | jq -SR '. as $line | try (fromjson) catch $line'"
          ];
        };
        nicelogs = {
          shortCut = "Shift-L";
          description = "Nice Logs (hl)";
          background = false;
          confirm = false;
          command = "bash";
          scopes = [ "all" ];
          args = [
            "-c"
            "hl -F --tail 200 <(kubectl logs -f $POD -c $NAME -n $NAMESPACE --context $CONTEXT)"
          ];
        };
      };
    };
  };
}

