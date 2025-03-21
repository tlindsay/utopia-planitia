{pkgs, ...}: {
  home.packages = with pkgs; [
    mysql80
    vault
  ];
}
