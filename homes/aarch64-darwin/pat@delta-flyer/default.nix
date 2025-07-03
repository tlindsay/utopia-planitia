{pkgs, ...}: {
  home.packages = with pkgs; [
    tpi
    rpi-imager
  ];
}
