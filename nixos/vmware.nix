{config, pkgs, ...}:
let
  cfg = config.services.vmwareGuest;
  open-vm-tools = if cfg.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;
in {
  services = {
    vmwareGuest.enable = true;
    vmwareGuest.headless = true;
  };
  # Fix for OpenSSH problems https://communities.vmware.com/thread/590825
  services.openssh.extraConfig = ''
    IPQoS=throughput
  '';
  programs.ssh.extraConfig = ''
    IPQoS=throughput
  '';
  system.activationScripts.vmwarehacks = if cfg.enable
      then ''
        mkdir -m 0755 -p /usr/bin
        ln -sfn ${open-vm-tools}/bin/vmhgfs-fuse /usr/bin/.vmhgfs-fuse.tmp
        mv -Tf /usr/bin/.vmhgfs-fuse.tmp /usr/bin/vmhgfs-fuse # atomically replace /usr/bin/vmhgfs-fuse
        ln -sfn ${pkgs.fuse}/bin/fusermount /usr/bin/.fusermount.tmp
        mv -Tf /usr/bin/.fusermount.tmp /usr/bin/fusermount # atomically replace /usr/bin/fusermount

        mkdir -m 0755 -p /lib
        ln -sfn $systemConfig/kernel-modules/lib/modules /lib/.modules.tmp
        mv -Tf /lib/.modules.tmp /lib/modules # atomically replace /lib/modules
      ''
      else ''
        rm -f /usr/bin/vmhgfs-fuse
        rm -f /usr/bin/fusermount
        rmdir --ignore-fail-on-non-empty /usr/bin /usr
        rm -f /lib/modules
        rmdir --ignore-fail-on-non-empty /lib
      '';
}
