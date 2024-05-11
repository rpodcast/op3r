create_base_url <- function() {
  root_url <- "https://op3.dev/api/1"
  return(root_url)
}

create_user_agent <- function() {
  "op3r (https://github.com/rpodcast/op3r)"
}

#' Create a Request for the OP3 API
#'
#' @return An [httr2::request] object
#' @noRd
req_op3 <- function() {
  req <- httr2::request(create_base_url()) |>
    httr2::req_user_agent(create_user_agent()) |>
    httr2::req_auth_bearer_token(get_op3_token()$api_token)
  return(req)
}