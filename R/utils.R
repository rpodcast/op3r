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
