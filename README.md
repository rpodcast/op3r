
<!-- README.md is generated from README.Rmd. Please edit that file -->

# op3r <img src='man/figures/logo.png' align="right" width="25%" min-width="120px"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`op3r` is an R package providing a tidy interface to the Open Prefix
Project (OP3) API created by [John
Spurlock](https://twitter.com/johnspurlock) available at
<https://op3.dev>

> The Open Podcast Prefix Project (OP3) is a free and open-source
> podcast prefix analytics service committed to open data and listener
> privacy.

## Installation

You can install the development version of op3r from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rpodcast/op3r")
```

## Configuration

The API endpoints supported by `op3r` require an API token. To obtain
your own set, create a free developer account at
<https://op3.dev/api/docs> and save the token as an environment
variables called `OP3_API_TOKEN` within a project-level or default
user-directory `.Renviron` file.

## Basic Usage

### Authentication

Save your OP3 API token in a project-level or user-level `.Renviron`
file using the following as a template:

    OP3_API_TOKEN="abcd123"

You can check whether authentication is working correctly with the
`op3_token_isset()` function:

``` r
library(op3r)
op3_token_isset()
```

### Example: Download Metrics

The following example shows how to obtain OP3 download metrics of the [R
Weekly Highlights](https://serve.podhome.fm/r-weekly-highlights)
Podcast.

``` r
# using the OP3 UUID for R Weekly Highlights
show_id <- "c008c9c7cfe847dda55cfdde54a22154"
op3_downloads_show(show_id = show_id)
#> # A tibble: 1 × 5
#>   days                monthlyDownloads weeklyAvgDownloads numWeeks download_data
#>   <chr>                          <int>              <int>    <int> <list>       
#> 1 111111111111111111…             2186                539        4 <tibble>
```

### Learn More

You can find a complete reference of the available functions as well as
a comprehensive getting started guide at
<https://rpodcast.github.io/op3r>.
