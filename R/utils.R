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

is_show_uuid <- function(x) {
  !stringr::str_starts(x, "http") & (stringr::str_length(x) == 32)
}

get_id_type <- function(x) {
  if (!any(is_rss_url(x), is_podcast_guid(x), is_show_uuid(x))) {
    cli::cli_abort(
      message = c(
        "show_id value does not appear to match a show UUID, podcast GUID, or RSS feed URL;"
      ),
      call = rlang::caller_env()
    )
  }
  if (is_rss_url(x)) return("rss")
  if (is_podcast_guid(x)) return("podcast_guid")
  if (is_show_uuid(x)) return("show_uuid")
}

assert_valid_limit <- function(limit, max_limit = 20000) {
  if (limit > max_limit) {
    cli::cli_abort(
      message = c(
        "maximum limit value supported for this function is {.var {max_limit}}."
      ),
      call = rlang::caller_env()
    )
  }
}

get_bot_downloads <- function(day_string) {
  x <- stringr::str_split_1(day_string, "") |> as.numeric()
  return(sum(x))
}
