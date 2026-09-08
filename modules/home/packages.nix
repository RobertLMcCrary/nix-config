{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
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
      curl

      # LSPs used by nvim (moved off Homebrew — see modules/darwin.nix homebrew.cleanup note)
      gopls
      lua-language-server
      typescript-language-server
      svelte-language-server
      vscode-langservers-extracted # vscode-html-language-server, vscode-css-language-server
      elixir-ls
      basedpyright
      jdt-language-server # provides `jdtls`
    ]
    # neovim, postgresql, and the nerd font come from Homebrew on Darwin
    # (see modules/darwin.nix homebrew.brews/casks) — Nix installs them
    # here only on NixOS/Linux, where there's no Homebrew.
    ++ lib.optionals stdenv.isLinux [
      neovim
      postgresql_18
      nerd-fonts.meslo-lg

      # Nix equivalents of the Homebrew-on-Mac dev CLIs above, so they
      # still exist on NixOS/Ubuntu. No Nix package for xcodebuildmcp, so
      # it's Mac-only.
      dbmate
      beamPackages.elixir
      ffmpeg
      flyctl
      gemini-cli
      mkcert
      openjdk21
      tokei
      typst
      whisper-cpp
      yt-dlp
      dotnet-sdk
      claude-code
      codex
      supabase-cli
      src-cli
    ];
}
