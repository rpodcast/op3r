op3_error_body <- function(resp) {
  resp_body <- httr2::resp_body_json(resp)
  if ("message" %in% names(resp_body)) {
    return(resp_body$message)
  }
  if ("error" %in% names(resp_body)) {
    return(resp_body$error)
  }
}

#' Get podcast show information
#' 
#' `op3_show()` obtains show-level information for a given podcast
#' using OP3.
#' @param show_id String representing an OP3 show UUID, podcast GUID, or
#'   a podcast RSS feed URL.
#' @param episodes Boolean to return episode-level metadata along with
#'   the show-level information. Default is `FALSE`.
#' 
#' @return `tibble` data frame with the following columns:
#' * `showUuid`: Podcast OP3 UUID
#' * `title`:  Podcast title
#' * `podcastGuid`: Podcast GUID
#' * `statsPageUrl`: URL of the OP3 statistics web page for the podcast
#' * `episodes_id`: Episode ID (when `episodes` is TRUE)
#' * `episodes_title`: Episode title (when `episodes` is TRUE)
#' @export
#' 
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#'
#' op3_show(show_id = "bb28afcc-137e-5c66-b231-4ffad7979b44")
op3_show <- function(show_id, episodes = FALSE) {
  if (is_rss_url(show_id)) {
    show_id <- base64url::base64_urlencode(show_id)
  }

  result_query <- req_op3() |>
    httr2::req_url_path_append(
      "shows",
      show_id
    )

  if (episodes) {
    result_query <- result_query |>
      httr2::req_url_query(
        episodes = "include"
      )
  } else {
    result_query <- result_query |>
      httr2::req_url_query(
        episodes = "exclude"
      )
  }
  result_query <- result_query |>
    httr2::req_error(body = op3_error_body)
  
  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)
  res_df <- tibble::as_tibble(result_json)
  if (episodes) {
    res_df <- res_df |>
      tidyr::unnest_wider(col = "episodes", names_sep = "_")
  }
  return(res_df)
}

op3_get_show_uuid <- function(show_guid = NULL, show_rss_url = NULL) {
  if (all(!is.null(show_guid), !is.null(show_rss_url))) {
    cli::cli_abort(
      "Only one of show_guid or show_rss_url can be specified.",
      call = rlang::caller_env()
    )
  }

  if (all(is.null(show_guid), is.null(show_rss_url))) {
    cli::cli_abort(
      "One of show_guid or show_rss_url must be specified.",
      call = rlang::caller_env()
    )
  }

  show_id <- purrr::compact(c(show_guid, show_rss_url))
  show_df <- op3_show(show_id)
  return(show_df$showUuid)
}
