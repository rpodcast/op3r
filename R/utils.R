env_var_present <- function(env_var) {
  x <- Sys.getenv(env_var, unset = NA_character_)
  if (is.na(x)) {
    return(FALSE)
  } else {
    return(x != '')
  }
}

#' Detect if OP3 API token is defined
#'
#' @return boolean, TRUE if 'OP3_API_TOKEN` is defined in the current
#'   R session.
#' @export
op3_api_isset <- function() {
  env_var_present("OP3_API_TOKEN")
}