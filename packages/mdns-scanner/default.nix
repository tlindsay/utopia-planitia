{
  inputs,
  pkgs,
  ...
}:
with pkgs; let
  inherit (inputs.fenix.packages.${system}.minimal) toolchain;
in
  (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  })
  .buildRustPackage rec {
    pname = "mdns-scanner";
    version = "v0.10.0";

    src = fetchFromGitHub {
      owner = "CramBL";
      repo = "mdns-scanner";
      rev = "v0.10.0";
      sha256 = null;
    };

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    doCheck = false;

    meta = {
      description = "Scan a network and create a list of IPs and associated hostnames, including mDNS hostnames and other aliases.";
      homepage = "https://github.com/CramBL/mdns-scanner";
      license = lib.licenses.mit;
      maintainers = [];
    };
  }
