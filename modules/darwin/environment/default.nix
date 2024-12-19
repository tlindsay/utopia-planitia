{
  inputs,
  system,
  ...
}: let
  nix-inspect = inputs.nix-inspect;
in {
  environment = {
    systemPackages = [nix-inspect.packages."${system}".default];
  };
}
