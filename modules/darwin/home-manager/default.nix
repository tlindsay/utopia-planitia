{ ... }: {
  home-manager = {
    backupFileExtension = "nix.bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
  };
}
