#' Retrieve client configuration information for the speedtest
#'
#' @export
spd_config <- function() {

  res <- httr::GET("http://www.speedtest.net/speedtest-config.php")

  httr::stop_for_status(res)

  config <- httr::content(res, as="text")
  config <- xml2::read_xml(config)
  config <- xml2::as_list(config)
  config <- purrr::map(config, function(.x) { c(.x, attributes(.x)) })
  config$`server-config`$ignoreids <- strsplit(config$`server-config`$ignoreids, ",")[[1]]

  config

}

