{
  description = "Peter's Emacs Flake";

  inputs =
    {
      nixpkgs = {
        url = "github:nixos/nixpkgs/master";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs = { nixpkgs.follows = "nixpkgs"; };
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        inputs = { nixpkgs.follows = "nixpkgs"; };
      };

      emacs-src = {
        url = "git+https:///mirrors.ustc.edu.cn/emacs.git";
        flake = false;
      };
    };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , emacs-overlay
    , emacs-src
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ emacs-overlay.overlay ];
        };

        peterzky-emacs = pkgs.callPackage ./default.nix {
          emacsGit = pkgs.emacsPgtk;
          epkgs-override = pkgs.callPackage ./override.nix { };
          inherit emacs-src;
        };
      in
      rec
      {
        packages.default = peterzky-emacs;
      }
      ) // rec {
      overlay = final: prev:
        (prev.lib.composeManyExtensions [ emacs-overlay.overlay overlays.peter-emacs ] final prev);
      overlays.peter-emacs = final: prev: rec {
        peter-emacs = prev.callPackage ./default.nix {
          emacsGit = prev.emacsPgtk;
          epkgs-override = prev.callPackage ./override.nix { };
          inherit emacs-src;
        };
      };

    };
}
  


