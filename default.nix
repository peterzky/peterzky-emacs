{ emacsWithPackagesFromUsePackage
, writeText
, symlinkJoin
, runCommand
, emacsGit
, universal-ctags
, global
, epkgs-override
, emacs-src  
}:
let
  org-file = writeText "default.org"
    (builtins.readFile ./init.org);

  emacs = emacsGit.overrideAttrs (old: rec {
    src = emacs-src;
    postInstall = old.postInstall + ''
      mv $out/bin/ctags $out/bin/emacs-ctags
    '';
  });

  emacs-config = runCommand "emacs-config" { } ''
    SITE_LISP=$out/share/emacs/site-lisp
    mkdir -p $SITE_LISP
    cp ${org-file} $SITE_LISP/default.org
    cd $SITE_LISP
    ${emacs}/bin/emacs -Q default.org --batch -f org-babel-tangle --kill
    rm $SITE_LISP/default.org
  '';

  emacs-with-packages =
    emacsWithPackagesFromUsePackage {
      config = builtins.readFile "${emacs-config}/share/emacs/site-lisp/default.el";
      package = emacs;
      override = epkgs-override;
      extraEmacsPackages = epkgs: with epkgs; [ emacs-config ];
    };
in
symlinkJoin {
  name = "emacs-bundle";
  paths = [
    emacs-with-packages
    universal-ctags
    global
  ];
}
