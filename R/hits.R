#' Get log record metadata for OP3 service
#' 
#' `op3_hits()` obtains lowest-level log records for every prefix redirect
#' processed by the OP3 service.
#' @param format result output format returned by the API endpoint. Possible
#'   values are `json` (object-based) or `json-a` (array-based) formats.
#' @param limit Integer of maximum number of episodes to return. The 
#'   maximum limit supported for this endpoint is `1000`. Default is `100`.
#' @param desc Boolean to return results in time-descending order. If `FALSE`,
#'   results are returned in time-ascending order. Default is `TRUE`.
#' @param start Optional date or date-time object to filter results to those
#'   starting at the supplied value. The object must be class `Date`. Default
#'   is `NULL`.
#' @param start_inclusive Boolean to consider the `start` date or date-time
#'   as inclusive for results. If `FALSE`, the `start` value is considered
#'   exclusive. Default is `TRUE`.
#' @param end Optional date or date-time object to filter results to those
#'   ending at the supplied value. The object must be class `Date`. Default
#'   is `NULL`.
#' @param url Optional string to fulter results by the specific URL providing
#'   the redirect. Default is `NULL`.
#' @param hashed_ip_address Optional string to filter results by the specific
#'   IP address secure hash. Default is `NULL`.
#' 
#' @return A`tibble` data frame if json format, otherwise a nested list if
#'   json-a format.
#' @export
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#'
#' op3_hits(limit = 10)
op3_hits <- function(format = "json", limit = 100, desc = TRUE, start = NULL, start_inclusive = TRUE, end = NULL, url = NULL, hashed_ip_address = NULL) {
  assert_valid_limit(limit, max_limit = 1000)
  
  result_query <- req_op3() |>
    httr2::req_url_path_append("hits")

  result_query <- result_query |>
    httr2::req_url_query(
      format = format,
      limit = limit
    )
  
  if (!is.null(start)) {
    start <- lubridate::format_ISO8601(start)
    start_list <- list(start)
    if (start_inclusive) {
      names(start_list) <- "start"
    } else {
      names(start_list) <- "startAfter"
    }
    result_query <- result_query |>
      httr2::req_url_query(!!!start_list)
  }

  if (!is.null(end)) {
    end <- lubridate::format_ISO8601(end)
    result_query <- result_query |>
      httr2::req_url_query(end = end)
  }

  if (!is.null(url)) {
    result_query <- result_query |>
      httr2::req_url_query(url = url)
  }

  if (!is.null(hashed_ip_address)) {
    result_query <- result_query |>
      httr2::req_url_query(hashedIpAddress = hashed_ip_address)
  }

  if (desc) {
    result_query <- result_query |>
      httr2::req_url_query(desc = TRUE)
  }

  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)

  if (format == "json-a") {
    return(result_json)
  }

  result_list <- result_json[["rows"]]
  res_df <- purrr::map(result_list, ~tibble::as_tibble(.x)) |>
    dplyr::bind_rows()
  return(res_df)
}