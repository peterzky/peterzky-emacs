{ lib, pkgs, ... }:
epkgs:
let
  _callPackage = lib.callPackageWith (pkgs // epkgs);
in
epkgs // {
  tree-sitter-langs = _callPackage ./pkgs/tree-sitter-langs { };

  tsc = _callPackage ./pkgs/tsc { };

  # eglot use libraries cames with emacs.
  # eglot = epkgs.eglot.overrideAttrs (
  #   old: rec {
  #     pname = "eglot";
  #     ename = "eglot";
  #     version = "999";
  #     src = pkgs.fetchFromGitHub {
  #       inherit (lib.importJSON ./pkgs/eglot/version.json) owner repo rev sha256;
  #     };
  #   }
  # );

  eglot = epkgs.eglot.override
    {
      xref = null;
      project = null;
      flymake = null;
      jsonrpc = null;
      eldoc = null;
    };
}
