let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };=
in
pkgs.mkShell.override { stdenv = pkgs.libcxxStdenv; } {
  buildInputs = [
    # Common Dependencies
    pkgs.cacert
    pkgs.git
    
    # Packages for each language are listed below. You can delete any if you don't need them.

    # C#
    pkgs.dotnet-sdk_8
    
    # C++
    pkgs.gcc13

    # Go
    pkgs.go

    # Java
    pkgs.jdk21

    # JavaScript
    pkgs.nodejs_21 pkgs.corepack_21

    # PHP
    pkgs.php83

    # Python
    pkgs.python312

    # Ruby
    pkgs.ruby_3_2
  ];
}