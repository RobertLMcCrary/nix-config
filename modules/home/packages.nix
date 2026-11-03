{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      go
      erlang
      gleam
      rebar3
      ripgrep
      fd
      jq
      ttyper
      typescript
      rustup
      # rustup's own bin/rust-analyzer is a proxy that recurses forever when the
      # active toolchain lacks the component (project pins 1.97.1), so ship the
      # real binary and let it win the bin/ collision.
      (lib.hiPrio rust-analyzer)
      # cargo/rustc/clippy/rustfmt come from rustup toolchains (projects pin
      # their own via rustup overrides); nixpkgs' rustc lags those pins.
      cargo-nextest
      cargo-edit
      cargo-deny
      bacon
      taplo # TOML LSP/formatter for Cargo.toml
      nixd
      nixfmt-rfc-style
      lua
      luarocks
      pkg-config
      stripe-cli
      curl

      # doom emacs (doom doctor): shell linting + markdown preview
      shellcheck
      pandoc

      # LSPs used by nvim (moved off Homebrew — see modules/darwin.nix homebrew.cleanup note)
      gopls
      lua-language-server
      typescript-language-server
      svelte-language-server
      vscode-langservers-extracted # vscode-html-language-server, vscode-css-language-server
      elixir-ls
      basedpyright
      jdt-language-server # provides `jdtls`
      sqls
    ]
    # neovim, node, postgresql, and the nerd font come from Homebrew on Darwin
    # (see modules/darwin.nix homebrew.brews/casks) — Nix installs them
    # here only on NixOS/Linux, where there's no Homebrew.
    ++ lib.optionals stdenv.isLinux [
      # Not on Darwin: nix's gcc/ld wrappers land first on PATH as `cc`/`ld`,
      # and cargo links through `cc` — GNU gcc has no macOS SDK, so every Rust
      # build script fails with "library not found for -liconv" and
      # rust-analyzer loses build-script/proc-macro data. Darwin uses Xcode's cc.
      gcc
      neovim
      nodejs
      postgresql_18
      nerd-fonts.meslo-lg

      # Nix equivalents of the Homebrew-on-Mac dev CLIs above, so they
      # still exist on NixOS/Ubuntu. No Nix package for xcodebuildmcp, so
      # it's Mac-only.
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
      codex
      supabase-cli
      src-cli
    ];
}
