let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
pkgs.mkShell.override { stdenv = pkgs.llvmPackages_18.libcxxStdenv; } {
  buildInputs = [
    # Common Dependencies
    pkgs.cacert
    pkgs.git
    
    # Packages for each language are listed below. You can delete any if you don't need them.

    # C#
    pkgs.dotnet-sdk_8
    
    # C++
    pkgs.gcc14

    # Go
    pkgs.go

    # Java
    pkgs.jdk22

    # JavaScript
    pkgs.nodejs_22 pkgs.nodePackages.pnpm

    # PHP
    pkgs.php83

    # Python
    pkgs.python312

    # Ruby
    pkgs.ruby_3_3
  ];
}
