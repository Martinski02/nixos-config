{ pkgs, ... }:

let
  windows = pkgs.writeShellApplication {
    name = "windows";

    runtimeInputs = [
      pkgs.efibootmgr
      pkgs.gawk
      pkgs.coreutils
    ];

    text = ''
      case "$#" in
        0) mode="boot" ;;
        1)
          if [[ "$1" == "--check" ]]; then
            mode="check"
          else
            echo "Verwendung: windows [--check]" >&2
            exit 2
          fi
          ;;
        *)
          echo "Verwendung: windows [--check]" >&2
          exit 2
          ;;
      esac

      windows_esp="4f64f78e-f436-4d47-83b7-9064c67d6d54"
      nixos_esp="dfaf0dcf-8296-4da6-8b7a-6cc895f5d4f4"

      if [[ ! -b "/dev/disk/by-partuuid/$windows_esp" ]]; then
        echo "Fehler: Windows-EFI-Partition nicht gefunden." >&2
        exit 1
      fi

      info="$(sudo ${pkgs.efibootmgr}/bin/efibootmgr -v)"
      order="$(printf '%s\n' "$info" | awk '/^BootOrder:/ { print $2; exit }')"

      if [[ -z "$order" ]]; then
        echo "Fehler: UEFI-Bootreihenfolge nicht lesbar." >&2
        exit 1
      fi

      linux_id="$(printf '%s\n' "$order" | cut -d, -f1)"
      linux_entry="$(printf '%s\n' "$info" |
        awk -v id="$linux_id" '$0 ~ ("^Boot" id "\\*") { print; exit }')"

      if [[ "$linux_entry" != *"$nixos_esp"* ||
            "$linux_entry" != *'\EFI\systemd\systemd-bootx64.efi'* ]]; then
        echo "Fehler: NixOS steht nicht an erster Stelle der Bootreihenfolge." >&2
        exit 1
      fi

      windows_id=""

      while IFS= read -r id; do
        entry="$(printf '%s\n' "$info" |
          awk -v id="$id" '$0 ~ ("^Boot" id "\\*") { print; exit }')"

        if [[ "$entry" == *"$windows_esp"* &&
              "$entry" == *'\EFI\Microsoft\Boot\bootmgfw'* ]]; then
          windows_id="$id"
          break
        fi
      done < <(printf '%s\n' "$order" | tr ',' '\n')

      if [[ -z "$windows_id" ]]; then
        echo "Fehler: Kein gültiger Windows-Eintrag in der Bootreihenfolge." >&2
        exit 1
      fi

      echo "NixOS-Standard: Boot$linux_id"
      echo "Windows-Ziel:   Boot$windows_id"

      if [[ "$mode" == "check" ]]; then
        echo "Prüfung erfolgreich. Keine Änderungen vorgenommen."
        exit 0
      fi

      sudo ${pkgs.efibootmgr}/bin/efibootmgr --bootnext "$windows_id"

      boot_next="$(sudo ${pkgs.efibootmgr}/bin/efibootmgr |
        awk '/^BootNext:/ { print $2; exit }')"

      if [[ "$boot_next" != "$windows_id" ]]; then
        echo "Fehler: BootNext konnte nicht verifiziert werden." >&2
        exit 1
      fi

      echo "BootNext bestätigt. Starte Windows ..."
      sudo systemctl reboot
    '';
  };
in
{
  environment.systemPackages = [
    windows
  ];
}
