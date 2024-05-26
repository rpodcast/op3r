let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/refs/heads/r-updates.tar.gz") {};
 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages) base64url cli DBI dbplyr devtools dplyr ggplot2 httptest2 httr2 jsonlite languageserver lifecycle lubridate purrr rhub rlang reactable RSQLite stringr tibble tidyr;
};
git_archive_pkgs = [
   (pkgs.rPackages.buildRPackage {
    name = "podindexr";
    src = pkgs.fetchgit {
      url = "https://github.com/rpodcast/podindexr";
      branchName = "main";
      rev = "3a29c2a9b714bee78cf5bf6ae974ab6314ac0333";
      sha256 = "sha256-JIIjibwfSy3OTrWitZgzq9GAR/OEE6hGUOglij9lTWs=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) cli digest dplyr glue httr2 purrr rlang tibble;
    };
  })

  (pkgs.rPackages.buildRPackage {
    name = "rhub";
    src = pkgs.fetchgit {
     url = "https://github.com/r-hub/rhub";
     branchName = "main";
     rev = "9b8e6abfe1230c5076ef310f9e49ff60bda870de";
     sha256 = "sha256-eg8fHy24S2uR6ns/DJUAPdBrXoDm/KxDT4Tl84zMoWw=";
    };
    propagatedBuildInputs = builtins.attrValues {
     inherit (pkgs.rPackages) callr cli curl desc gert glue gitcreds jsonlite pkgbuild processx rappdirs rematch R6 rprojroot whoami;
    };
  })];
   system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocales vscodium nix pandoc qpdf;
};
  wrapped_pkgs = pkgs.radianWrapper.override {
   packages = [ rpkgs ];
};
  in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [ git_archive_pkgs rpkgs  system_packages wrapped_pkgs ];
      
  }

