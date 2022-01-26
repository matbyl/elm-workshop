let
  nixos_21_05 = import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz") { };
in nixos_21_05.mkShell {
  buildInputs = [
    nixos_21_05.nodejs-12_x
    nixos_21_05.elmPackages.elm
    nixos_21_05.elmPackages.elm-format
    nixos_21_05.elmPackages.elm-analyse
    nixos_21_05.nodePackages.parcel-bundler
    nixos_21_05.nixfmt
  ];
}
