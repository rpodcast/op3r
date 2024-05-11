env_var_present <- function(env_var) {
  x <- Sys.getenv(env_var, unset = NA_character_)
  if (is.na(x)) {
    return(FALSE)
  } else {
    return(x != '')
  }
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

is_rss_url <- function(x) {
  stringr::str_starts(x, "http")
}

# https://www.geeksforgeeks.org/how-to-validate-guid-globally-unique-identifier-using-regular-expression/
is_podcast_guid <- function(x) {
  stringr::str_detect(x, "^[{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?$")
}