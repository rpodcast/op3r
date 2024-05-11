op3_show <- function(show_id, episodes = FALSE) {
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

  # TODO: Add post-processing code for converting nested list to tidy data frame
  return(result_json)
}