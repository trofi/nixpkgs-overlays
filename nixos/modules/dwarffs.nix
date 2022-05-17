{ pkgs, ... }:
{
  config = {
    systemd.packages = [ pkgs.dwarffs ];
    system.fsPackages = [ pkgs.dwarffs ];
    systemd.units."run-dwarffs.automount".wantedBy = [ "multi-user.target" ];
    environment.variables.NIX_DEBUG_INFO_DIRS = [ "/run/dwarffs" ];
    systemd.tmpfiles.rules = [ "d /var/cache/dwarffs 0755 dwarffs dwarffs 7d" ];

    users.users.dwarffs =
      { description = "Debug symbols file system daemon user";
        group = "dwarffs";
        isSystemUser = true;
      };

    users.groups.dwarffs = {};
  };
}
