{ lib, pkgs, ... }:
epkgs:
let
  _callPackage = lib.callPackageWith (pkgs // epkgs);
in
epkgs // {
  tree-sitter-langs = _callPackage ./pkgs/tree-sitter-langs { };

  tsc = _callPackage ./pkgs/tsc { };

  eglot = epkgs.eglot.override
    {
      xref = null;
      project = null;
      flymake = null;
      jsonrpc = null;
      eldoc = null;
    };
  tabnine-capf = _callPackage ./pkgs/tabnine-capf { };
}
