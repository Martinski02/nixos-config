{ pkgs, ... }:

let
  resetTouchpad = pkgs.writeShellScriptBin "reset-touchpad" ''
    set -euo pipefail

    device="i2c-SYNA2BA6:00"
    driver="/sys/bus/i2c/drivers/i2c_hid_acpi"

    echo "$device" > "$driver/unbind"
    sleep 2
    echo "$device" > "$driver/bind"
    sleep 3

    echo "Touchpad wurde neu verbunden."
  '';
in
{
  environment.systemPackages = with pkgs; [
    git
    resetTouchpad
  ];
}
