{ ... }: {
    # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  #users.groups.vboxsf = {};
  # Add vboxsf group to the vagrant user
  users.users.vagrant.extraGroups = [ "vboxsf" ];
}
