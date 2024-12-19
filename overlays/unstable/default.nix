# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{channels, ...}: final: prev: {
  inherit
    (channels.nixpkgs-unstable)
    atuin
    mqttui
    neovim
    tailscale
    golangci-lint
    fastly
    git
    git-town
    ;
}
