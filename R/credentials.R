#' Detect if OP3 API token is defined
#'
#' @return boolean, TRUE if 'OP3_API_TOKEN` is defined in the current
#'   R session.
#' @export
op3_token_isset <- function() {
  env_var_present("OP3_API_TOKEN")
}

#' Obtain OP3 API token
#'
#' Obtain the OP3 API token from a `.Renviron` file, either stored in the
#' current directory or the user's home directory.
#' @return list with API token
#' @export
get_op3_token <- function() {
  if (!op3_token_isset()) {
    cli::cli_abort("Unable to find OP3 API token. Please create a developer account at {.url https://op3.dev/api/keys} and set {.envvar OP3_API_TOKEN} environment variable inside your {.file ~/.Renviron} file.")
  } else {
    return(
      list(
        api_token = Sys.getenv("OP3_API_TOKEN")
      )
    )
  }
}