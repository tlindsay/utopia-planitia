{channels, ...}: final: prev: {
  inherit
    (channels.nixpkgs-unstable)
    atuin
    claude-code
    fastly
    golangci-lint
    k9s
    moar
    mqttui
    neovim
    nh
    spotify-player
    tailscale
    tinygo
    wgpu-utils
    ;
}
