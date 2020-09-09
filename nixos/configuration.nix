{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
      ./provider.nix
      ./vagrant.nix
    ];
  # require = [ <nixos/nixos/modules/installer/scan/not-detected.nix> ];
  boot = {
    # Use the GRUB 2 boot loader
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device   = "/dev/sda";
    supportedFilesystems = ["nfs4"];
  };

  environment.systemPackages = with pkgs; [ vim git ruby gnumake gcc ];
  # fileSystems = [ { mountPoint = "/"; label = "nixos"; } ];
  security.sudo.configFile =
    ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults lecture = never
    '';
  security.sudo.wheelNeedsPassword = false;
  #security.sudo.extraConfig =
  #  ''
  #    %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
  #  '';
  services = {
    #dbus.enable       = true;
    openssh.enable    = true;
    #virtualbox.enable = true;
  };
  users = {
    mutableUsers = false;
    extraGroups = [ { name = "vagrant"; } { name = "vboxsf"; } ];
    extraUsers  = [ {
      description     = "Vagrant User";
      name            = "vagrant";
      group           = "vagrant";
      extraGroups     = [ "users" "vboxsf" "wheel" ];
      password        = "vagrant";
      home            = "/home/vagrant";
      createHome      = true;
      useDefaultShell = true;
    } ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
