#' Retrieve client configuration information for the speedtest
#'
#' @md
#' @export
#' @examples \dontrun{
#' spd_config()
#' }
spd_config <- function() {

  res <- httr::GET("http://www.speedtest.net/speedtest-config.php")

  httr::stop_for_status(res)

  config <- httr::content(res, as="text", encoding="UTF-8")
  config <- xml2::read_xml(config)
  config <- xml2::as_list(config)
  config <- config$settings
  config <- purrr::map(config, function(.x) { c(.x, attributes(.x)) })
  config$`server-config`$ignoreids <- strsplit(config$`server-config`$ignoreids, ",")[[1]]

  sz <- as.numeric(gsub("[^[:digit:]]", "", config$upload$mintestsize))

  if (grepl("[^[:digit:]]", config$upload$mintestsize)) {
    up_units <- gsub("[[:digit:]]", "", config$upload$mintestsize)
    sz <- as.numeric(gsub("[^[:digit:]]", "", config$upload$mintestsize))
    sz <- sz * switch(up_units, K=1024, M=1024000)
  }

  config$upload$mintestsize <- sz

  config

}

