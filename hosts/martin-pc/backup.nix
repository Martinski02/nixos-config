{ pkgs, ... }:

let
  borgServeMartinServer = pkgs.writeShellScript "borg-serve-martin-server" ''
    set -eu

    expected_uuid="2d475f45-d265-407f-8685-398b8228a1f3"
    repository="/mnt/backup/martin-server"

    target="$(${pkgs.util-linux}/bin/findmnt -rn -o TARGET --target /mnt/backup 2>/dev/null || true)"
    fstype="$(${pkgs.util-linux}/bin/findmnt -rn -o FSTYPE --target /mnt/backup 2>/dev/null || true)"
    uuid="$(${pkgs.util-linux}/bin/findmnt -rn -o UUID --target /mnt/backup 2>/dev/null || true)"

    if [ "$target" != "/mnt/backup" ] \
      || [ "$fstype" != "ext4" ] \
      || [ "$uuid" != "$expected_uuid" ]; then
      echo "Borg access refused: expected backup SSD is not mounted at /mnt/backup." >&2
      exit 1
    fi

    if [ ! -d "$repository" ]; then
      echo "Borg access refused: repository path does not exist." >&2
      exit 1
    fi

    exec ${pkgs.borgbackup}/bin/borg serve \
      --append-only \
      --restrict-to-repository "$repository"
  '';

  borgServeMartinServerSecrets = pkgs.writeShellScript "borg-serve-martin-server-secrets" ''
    set -eu

    expected_uuid="2d475f45-d265-407f-8685-398b8228a1f3"
    repository="/mnt/backup/martin-server-secrets"

    target="$(${pkgs.util-linux}/bin/findmnt -rn -o TARGET --target /mnt/backup 2>/dev/null || true)"
    fstype="$(${pkgs.util-linux}/bin/findmnt -rn -o FSTYPE --target /mnt/backup 2>/dev/null || true)"
    uuid="$(${pkgs.util-linux}/bin/findmnt -rn -o UUID --target /mnt/backup 2>/dev/null || true)"

    if [ "$target" != "/mnt/backup" ] \
      || [ "$fstype" != "ext4" ] \
      || [ "$uuid" != "$expected_uuid" ]; then
      echo "Borg access refused: expected backup SSD is not mounted at /mnt/backup." >&2
      exit 1
    fi

    if [ ! -d "$repository" ]; then
      echo "Borg access refused: repository path does not exist." >&2
      exit 1
    fi

    exec ${pkgs.borgbackup}/bin/borg serve \
      --append-only \
      --restrict-to-repository "$repository"
  '';
in
{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];

  users.groups.borgbackup = {};

  users.users.borgbackup = {
    isSystemUser = true;
    group = "borgbackup";
    description = "Restricted Borg backup receiver";
    home = "/var/lib/borgbackup";
    createHome = true;
    shell = pkgs.bashInteractive;

    openssh.authorizedKeys.keys = [
      ''from="100.115.246.95",restrict,command="${borgServeMartinServer}" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJf6gmATwa2uQadhVPMLxQkd6RHzkQ6P5ei2zb5Vtb/k borg-martin-server-to-martin-pc''
      ''from="100.115.246.95",restrict,command="${borgServeMartinServerSecrets}" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzr7ugYu22aLD9MZDh/9y7nXRvRhnWB/0EpaHjw1glu borg-secrets martin-server -> martin-pc''
    ];
  };
}
