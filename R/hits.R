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

  result_list <- result_json[["rows"]]
  res_df <- purrr::map(result_list, ~tibble::as_tibble(.x)) |>
    dplyr::bind_rows()
  return(res_df)
}