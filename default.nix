let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/refs/heads/r-updates.tar.gz") {};
 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages) cli devtools dplyr httptest2 httr2 jsonlite languageserver lifecycle purrr rlang stringr tibble tidyr;
};
   system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocales vscodium nix;
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

    buildInputs = [  rpkgs  system_packages  ];
      
  }

