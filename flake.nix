{
  description = "Shayla development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
  outputs = { self, nixpkgs, ... }:
    let
      x86_64 = let pkgs = import nixpkgs { system = "x86_64-darwin"; };
      in pkgs.mkShell { buildInputs = [ pkgs.cmake pkgs.ninja pkgs.pkg-config ]; };
      aarch64 = let pkgs = import nixpkgs { system = "aarch64-darwin"; };
      in pkgs.mkShell { buildInputs = [ pkgs.cmake pkgs.ninja pkgs.pkg-config ]; };
    in {
      devShells = {
        x86_64-darwin.default = x86_64;
        aarch64-darwin.default = aarch64;
      };
    };
}
