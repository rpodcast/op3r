#' Get recent episodes with transcripts
#' 
#' `op3_transcripts()` obtains the most recent episodes
#' of podcasts using OP3 contain transcripts along with
#' their daily download numbers.
#' @param limit Integer of maximum number of episodes to
#' return. The maximum limit supported is 100.
#' 
#' @return `tibble` data frame with the following columns:
#' * `asof`: Timestamp
#' * `pubdate`: Episode publish timestamp
#' * `podcastGuid`: Podcast GUID
#' * `episodeItemGuid`: Episode GUID
#' * `hasTranscripts`: Boolean indicating if the episode has a transcript
#' * `dailyDownloads`: List of episode download numbers by date
op3_transcripts <- function(limit = 100) {
  assert_valid_limit(limit, max_limit = 100)
  result_query <- req_op3() |>
    httr2::req_url_path_append(
      "queries",
      "recent-episodes-with-transcripts"
    ) |>
    httr2::req_url_query(
      limit = limit
    )

  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)
  res_list <- purrr::pluck(result_json, "rt")
  res_df <- tibble::as_tibble(res_list) |>
    tidyr::unnest_wider(col = "episodes")

  return(res_df)
}

#' Get download numbers by application for a show
#' 
#' `op3_top_show_apps()` obtains the download numbers for individual
#' podcast applications over the last three calendar months
#' for a specific show.
#' 
#' @param show_id String representing an OP3 show UUID, podcast GUID, or
#'   a podcast RSS feed URL.
#' 
#' @return `tibble` data frame with the following columns:
#' * `show_uuid`: OP3 show UUID
#' * `app_name`: Name of podcast application
#' * `value`: Number of downloads in the last three calendar months
#' @export
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#'
#' op3_top_show_apps(show_id = "bb28afcc-137e-5c66-b231-4ffad7979b44")
op3_top_show_apps <- function(show_id) {
  id_type <- get_id_type(show_id)
  query_param <- switch(id_type,
    rss = "feedUrlbase64",
    podcast_guid = "podcastGuid",
    show_uuid = "showUuid"
  )

  if (is_rss_url(show_id)) {
    show_id <- base64url::base64_urlencode(show_id)
  }

  query_list <- list(show_id)
  names(query_list) <- query_param
  result_query <- req_op3() |>
    httr2::req_url_path_append(
      "queries",
      "top-apps-for-show"
    ) |>
    httr2::req_url_query(!!!query_list)

  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)

  res_df <- purrr::map_dfr(result_json$appDownloads, ~ .x |> tibble::as_tibble(), .id = "app_name")
  res_df$show_uuid <- result_json$showUuid
  return(res_df)
}

#' Get top apps by share of downloads
#' 
#' `op3_top_apps()` obtains global shares of application downloads over the
#' last thirty days categorized by application
#' @param device_name Optional string of a specific device ID to constrain
#'   results. 
#' @return `tibble` data frame with the following columns:
#' * `app_name`: Device name
#' * `value`: Percentage of download share
#' * `min_date`: Oldest date in data range
#' * `max_date`: Newest date in data range
#' @export
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#'
#' op3_top_apps()
op3_top_apps <- function(device_name = NULL) {
  result_query <- req_op3() |>
    httr2::req_url_path_append(
      "queries",
      "top-apps"
    )
  # TODO: Add function to check validity of device name
  if (!is.null(device_name)) {
    result_query <- result_query |>
      httr2::req_url_query(deviceName = device_name)
  }

  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)
  
  res_df <- purrr::map_dfr(result_json$appShares, ~ .x |> tibble::as_tibble(), .id = "app_name")
  res_df$min_date <- result_json$minDate
  res_df$max_date <- result_json$maxDate
  return(res_df)
}

#' Get monthly and weekly show download counts
#' 
#' `op3_downloads_show()` obtains the number of monthly downloads and average
#' weekly downloads over the last four weeks (excludes bots)
#' @param show_id One or more character strings of OP3 show UUID values
#' 
#' @return tibble (TODO FINISH)
#' @export
#' @examplesIf op3r::op3_token_isset()
#' # Requires API token
#'
#' op3_downloads_show(show_id = "a18389b8a52d4112a782b32f40f73df6")
op3_downloads_show <- function(show_id) {
  # verify that supplied show_id is a valid OP3 UUID
  # TODO Finish error message
  if (any(purrr::map_lgl(show_id, ~!is_show_uuid(.x)))) {
    cli::cli_abort(
      message = c(
        "One or more show_id values are not valid OP3 UUID values."
      ),
      call = rlang::caller_env()
    )
  }

  result_query <- req_op3() |>
    httr2::req_url_path_append(
      "queries",
      "show-download-counts"
    )

  result_query <- result_query |>
    httr2::req_url_query(showUuid = show_id, .multi = "explode")

  result_raw <- httr2::req_perform(result_query)
  result_json <- httr2::resp_body_json(result_raw)
  return(result_json)
}