test_that("error for invalid limit", {
  expect_error(
    assert_valid_limit(limit = 50000, max_limit = 20000),
    "maximum limit",
    ignore.case = TRUE
  )
})

with_mock_dir("q_transcripts", {
  test_that("op3_transcripts returns tibble", {
    df <- op3_transcripts(limit = 5)
    expect_s3_class(df, "tbl_df")
  })
})

with_mock_dir("q_transcripts", {
  test_that("daily downloads is list by default", {
    df <- op3_transcripts(limit = 5)
    expect_type(df$dailyDownloads, "list")
  })
})

with_mock_dir("q_top", {
  test_that("op3_top_show_apps returns tibble", {
    show_guid <- "bb28afcc-137e-5c66-b231-4ffad7979b44"
    df <- op3_top_show_apps(show_guid)
    expect_s3_class(df, "tbl_df")
  })
})

with_mock_dir("q_top_apps", {
  test_that("op3_top_apps returns tibble", {
    df <- op3_top_apps()
    expect_s3_class(df, "tbl_df")
  })
})

with_mock_dir("q_dl_show", {
  test_that("op3_downloads_show tibble", {
    show_uuid <- "c008c9c7cfe847dda55cfdde54a22154"
    df <- op3_downloads_show(show_uuid)
    expect_s3_class(df, "tbl_df")
  })
})
