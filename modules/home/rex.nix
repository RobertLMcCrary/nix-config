{ config, lib, pkgs, ... }:
let
  rex = lib.getExe config.programs.rex.package;
in
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

  # Sessions live only as long as the server, so recreate the persistent
  # `agents` session (for Claude Code, Codex, builds) after every boot.
  systemd.user.services.rex-agents = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Ensure the Rex 'agents' session exists";
      After = [ "rex.service" ];
      Requires = [ "rex.service" ];
    };
    Service = {
      Type = "oneshot";
      WorkingDirectory = config.home.homeDirectory;
      ExecStart = toString (
        pkgs.writeShellScript "rex-agents" ''
          ${rex} ls | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.gnugrep}/bin/grep -qx agents \
            || ${rex} new agents --cwd "$HOME"
        ''
      );
    };
    Install.WantedBy = [ "default.target" ];
  };
}
