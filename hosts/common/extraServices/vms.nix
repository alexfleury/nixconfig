{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.vms;
in {
  options.extraServices.vms.enable = mkEnableOption "enable virtualization extra services";

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    # Group set in set in users.users.<username>.extraGroups,
    # but it could also be done by uncommenting the next line.
    #users.groups.libvirtd.members = [ get.username.from.option? ];

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    networking.firewall.trustedInterfaces = ["virbr0"];

    # To solve the default network error.
    # Imperative way: sudo virsh net-autostart default
    systemd.services.libvirt-default-network = {
      description = "Start libvirt default network";
      after = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
        ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
        User = "root";
      };
    };
  };
}
