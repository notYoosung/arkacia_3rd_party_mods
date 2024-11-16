{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.lua
    pkgs.luajit
    pkgs.luaPackages.luacheck
    pkgs.jq
  ];
}
