# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{channels, ...}: final: prev: {
  inherit
    (channels.nixpkgs-unstable)
    astroterm
    atuin
    fastly
    golangci-lint
    mqttui
    neovim
    tailscale
    tinygo
    ;
}
