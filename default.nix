{ emacsWithPackagesFromUsePackage, writeText, runCommand, emacsGit, emacs-src, epkgs-override }:
let
  org-file = writeText "default.org"
    (builtins.readFile ./init.org);

  emacs = emacsGit.overrideAttrs (_: rec {
    src = emacs-src;
  });

  emacs-config = runCommand "emacs-config" { } ''
    SITE_LISP=$out/share/emacs/site-lisp
    mkdir -p $SITE_LISP
    cp ${org-file} $SITE_LISP/default.org
    cd $SITE_LISP
    ${emacs}/bin/emacs -Q default.org --batch -f org-babel-tangle --kill
    rm $SITE_LISP/default.org
  '';

in
emacsWithPackagesFromUsePackage {
  config = builtins.readFile "${emacs-config}/share/emacs/site-lisp/default.el";
  package = emacs;
  override = epkgs-override;
  extraEmacsPackages = epkgs: with epkgs; [
    emacs-config
  ];

}
