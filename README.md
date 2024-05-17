
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

    #> [1] TRUE

### Recent Downloads with Transcripts

``` r
op3_transcripts(limit = 5, nest_downloads = FALSE)
#> # A tibble: 5 × 7
#>   asof             pubdate podcastGuid episodeItemGuid hasTranscripts date      
#>   <chr>            <chr>   <chr>       <chr>           <lgl>          <date>    
#> 1 2024-05-16T00:0… 2024-0… 451330fc-9… 65978d90-52e4-… TRUE           2024-05-15
#> 2 2024-05-16T00:0… 2024-0… 43a4f801-0… 92038b82-09f8-… TRUE           2024-05-15
#> 3 2024-05-16T00:0… 2024-0… f81ee600-3… 16f852e2-7c03-… TRUE           2024-05-15
#> 4 2024-05-16T00:0… 2024-0… 66ae706b-9… bec625a1-7a5a-… TRUE           2024-05-15
#> 5 2024-05-16T00:0… 2024-0… 1f23616e-6… b181f8db-ade2-… TRUE           2024-05-15
#> # ℹ 1 more variable: n_downloads <dbl>
```
