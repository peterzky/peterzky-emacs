{
  description = "Peter's Emacs Flake";

  inputs =
    {
      nixpkgs = {
        # url = "github:nixos/nixpkgs/master";
        url = "nixpkgs";
      };

      flake-utils.url = "github:numtide/flake-utils";

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        inputs = { nixpkgs.follows = "nixpkgs"; };
      };

    };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , emacs-overlay
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ emacs-overlay.overlay ];
        };

        epkgs-override = pkgs.callPackage ./override.nix { };

        peterzky-emacs = pkgs.callPackage ./default.nix {
          emacsGit = pkgs.emacsGit;
          inherit epkgs-override;
        };
      in
      rec
      {
        packages.default = peterzky-emacs;
      }
      );
}
  


