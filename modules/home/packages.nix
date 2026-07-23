{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    go
    ripgrep
    fd
    jq
    ttyper
    nodejs
    typescript
    rustup
    nixd
    nixfmt-rfc-style
    lua
    luarocks
    gcc
    pkg-config
    stripe-cli
  ];
}
