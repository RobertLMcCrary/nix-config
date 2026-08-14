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

    # LSPs used by nvim (moved off Homebrew — see modules/darwin.nix homebrew.cleanup note)
    gopls
    lua-language-server
    typescript-language-server
    svelte-language-server
    vscode-langservers-extracted # vscode-html-language-server, vscode-css-language-server
    elixir-ls
    pyright
    jdt-language-server # provides `jdtls`
  ];
}
