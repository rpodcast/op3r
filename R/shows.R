#' Get podcast show information
#' 
#' `op3_show()` obtains show-level information for a given podcast
#' using OP3.
#' @param show_id String representing an OP3 show UUID, podcast GUID, or
#'   a podcast RSS feed URL.
#' @param episodes Boolean to return episode-level metadata along with
#'   the show-level information. Default is `FALSE`.
#' 
#' @return `tibble` data frame with show-level information and episode
#'   information if requested.
#' @export
#' 
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#' 
#' op3_show(show_id = bb28afcc-137e-5c66-b231-4ffad7979b44")
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
  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)
  res_df <- tibble::as_tibble(result_json)
  if (episodes) {
    res_df <- res_df |>
      tidyr::unnest_wider(col = "episodes", names_sep = "_")
  }
  return(res_df)
}