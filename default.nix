let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/refs/heads/r-updates.tar.gz") {};
 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages) base64url cli DBI dbplyr devtools dplyr ggplot2 httptest2 httr2 jsonlite languageserver lifecycle lubridate purrr rlang reactable RSQLite stringr tibble tidyr;
};
git_archive_pkgs = [(pkgs.rPackages.buildRPackage {
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
  }) ];
   system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocales vscodium nix pandoc qpdf;
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

    buildInputs = [ git_archive_pkgs rpkgs  system_packages  ];
      
  }

