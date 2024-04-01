let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  nixpkgs_old = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  pkgs_old = import nixpkgs_old { config = {}; overlays = []; };
in
pkgs.mkShell.override { stdenv = pkgs.libcxxStdenv; } {
  buildInputs = [
    # Common Dependencies
    pkgs.cacert
    pkgs.git
    
    # Packages for each language are listed below. You can delete any if you don't need them.

    # C#, F#
    pkgs.dotnet-sdk_8
    
    # C++
    pkgs.gcc13

    # Go
    pkgs.go

    # Java
    pkgs.jdk21

    # JavaScript, PureScript, ReScript
    pkgs.nodejs_21 pkgs.corepack_21

    # PHP
    pkgs.php83

    # Python
    pkgs.python312

    # Ruby
    pkgs.ruby_3_2


    # CoffeeScript
    pkgs.coffeescript

    # Dart
    pkgs.dart
    
    # Elixir
    pkgs.elixir_1_16

    # Groovy
    pkgs.groovy

    # Kotlin
    pkgs.kotlin

    # Objective-C
    pkgs.gnustep.base pkgs.gnustep.libobjc

    # Perl
    pkgs.perl

    # Rust
    pkgs.rustc

    # Scala
    pkgs.scala_3

    # Swift
    pkgs_old.swiftPackages.swift pkgs_old.swiftPackages.Foundation

    # TypeScript
    pkgs.typescript


    # Clojure
    pkgs.clojure

    # Crystal
    pkgs.crystal

    # D
    pkgs.dmd

    # Elm
    pkgs.elmPackages.elm

    # Erlang
    pkgs.erlang_26

    # Hack
    (builtins.getFlake "git+https://github.com/facebook/hhvm.git?submodules=1&shallow=1&ref=refs/tags/HHVM-4.164.0").packages.x86_64-linux.default

    # Haskell
    pkgs.haskell.compiler.ghc981

    # Julia
    pkgs.julia

    # Lua
    pkgs.lua5_4_compat

    # Nim
    pkgs.nim2

    # OCaml
    pkgs.ocaml
    
    # PureScript
    pkgs.purescript

    # Racket
    pkgs.racket-minimal
  ];
}