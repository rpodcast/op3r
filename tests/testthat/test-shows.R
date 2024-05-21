with_mock_dir("s_getshow_rss", {
  test_that("op3_get_show_id with rss gets uuid", {
    show_rss_url <- "https://serve.podhome.fm/rss/bb28afcc-137e-5c66-b231-4ffad7979b44"
    show_uuid <- "c008c9c7cfe847dda55cfdde54a22154"
    expect_equal(op3_get_show_uuid(show_rss_url = show_rss_url), show_uuid)
  })
})

with_mock_dir("s_getshow_guid", {
  test_that("op3_get_show_id with guid gets uuid", {
    show_guid <- "bb28afcc-137e-5c66-b231-4ffad7979b44"
    show_uuid <- "c008c9c7cfe847dda55cfdde54a22154"
    expect_equal(op3_get_show_uuid(show_guid = show_guid), show_uuid)
  })
})


with_mock_dir("s_show_rss", {
  test_that("op3_show with rss returns tibble", {
    show_rss_url <- "https://serve.podhome.fm/rss/bb28afcc-137e-5c66-b231-4ffad7979b44"
    df <- op3_show(show_id = show_rss_url)
    expect_s3_class(df, "tbl_df")
  })
})

with_mock_dir("s_show_guid", {
  test_that("op3_show with guid returns tibble", {
    show_guid <- "bb28afcc-137e-5c66-b231-4ffad7979b44"
    df <- op3_show(show_id = show_guid)
    expect_s3_class(df, "tbl_df")
  })
})

with_mock_dir("s_show_uuid", {
  test_that("op3_show with uuid returns tibble", {
    show_uuid <- "c008c9c7cfe847dda55cfdde54a22154"
    df <- op3_show(show_id = show_uuid)
    expect_s3_class(df, "tbl_df")
  })
})
