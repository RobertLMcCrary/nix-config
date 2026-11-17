{ pkgs, ... }:
{
  # Rex (Superlogical's multiplexer). The rex command and its xterm-rex
  # terminfo on every machine; on Linux also a personal server as a
  # systemd user service, reached from Rex for Mac at
  # ssh://robertmccrary@nixos-laptop over Tailscale. On macOS the Rex app
  # runs the server itself.
  programs.rex = {
    enable = true;
    # ~/.ssh/config isn't managed by home-manager; `rex terminfo setup`
    # adds the ssh TERM guard to it instead.
    sshGuard = false;
  };
  services.rex.enable = pkgs.stdenv.isLinux;
}
