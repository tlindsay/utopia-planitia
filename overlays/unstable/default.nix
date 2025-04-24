{channels, ...}: final: prev: {
  inherit
    (channels.nixpkgs-unstable)
    atuin
    claude-code
    fastly
    golangci-lint
    k9s
    mqttui
    neovim
    spotify-player
    tailscale
    tinygo
    wgpu-utils
    ;
}
