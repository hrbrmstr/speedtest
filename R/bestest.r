#' Find "best" servers (latency-wise) from master server list
#'
#' @md
#' @param servers if not `NULL`, then the data frame from [spd_servers()]. If
#'        `NULL`, then [spd_servers()] will be called to retrieve the server list.
#' @param config client configuration retrieved via [spd_config()]. If `NULL` it
#'        will be retrieved
#' @return server list in order of latency closeness (retrieval speed column included)
#' @note the list of target servers will be truncated to the first 10
#' @export
spd_best_servers <- function(servers=NULL, config=NULL) {

  if (is.null(config)) config <- spd_config()
  if (is.null(servers)) servers <- spd_closest_servers(config=config)

  targets <- servers

  if (nrow(targets) > 10) targets <- servers[1:10,]

  .lat_dat <- list()

  .COK <- function(res) {
    .lat_dat <<- c(.lat_dat, list(res))
  }

  .CERR <- function(res) { cat("X")}

  targets$latency_url <- file.path(dirname(targets$url), "latency.txt")
  purrr::walk(targets$latency_url, curl::curl_fetch_multi, .COK, .CERR)

  curl::multi_run()

  purrr::map_df(.lat_dat, ~{
    data_frame(
      latency_url = .x$url,
      ping_time = mean(pingr::ping(urltools::domain(.x$url)), na.rm=TRUE)/1000,
      total_time = .x$times["total"],
      retrieval_time = .x$times[6] - .x$times[5],
      test_result = rawToChar(.x$content)
    )
  }) %>%
  dplyr::filter(!grepl("test=test", retrieval_time)) -> target_df

  # order() is kinda not necessary since the first ones to finish are going to be
  # in the list first, but it's best to be safe

  dplyr::left_join(target_df, targets, "latency_url") %>%
    dplyr::arrange(retrieval_time) %>%
    dplyr::select(-latency_url, -test_result)

}

