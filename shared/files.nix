{ pkgs, config, ... }:

# let
#  githubPublicKey = "ssh-ed25519 AAAA...";
# in
{
  "shared.txt" = {
    text = "this is from shared/files.nix";
  };
}
