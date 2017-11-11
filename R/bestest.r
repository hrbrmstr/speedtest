#' Find "best" servers (latency-wise) from master server list
#'
#' The input `servers` data frame will be truncatred to the first `max` and
#' HTTP and ICMP probe tests will be performed to determine initial retrieval
#' speed and latency. Not all servers respond to ICMP requests due to the way
#' their routers, switches or firewalls are configured.
#'
#' @md
#' @param servers if not `NULL`, then the data frame from [spd_servers()]. If
#'        `NULL`, then [spd_servers()] will be called to retrieve the server list.
#' @param config client configuration retrieved via [spd_config()]. If `NULL` it
#'        will be retrieved
#' @param max the maximum numbers of "best" servers to return. This is hard-capped
#'        at 25 since Oookla is a free/sponsored service and if you plan on abusing
#'        it you'll have to write your own code to do so. Default is `10`.
#' @return server list in order of latency closeness (retrieval speed column included)
#' @note the list of target servers will be truncated to the first `max`. `max` may
#'       amount may not be returned if there were errors connecting to servers.
#' @export
spd_best_servers <- function(servers=NULL, config=NULL, max=10) {

  if (max > 25) max <- 25
  if (is.null(config)) config <- spd_config()
  if (is.null(servers)) servers <- spd_closest_servers(config=config)

  targets <- servers

  if (nrow(targets) > max) targets <- servers[1:max,]

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

  dplyr::left_join(target_df, targets, "latency_url") %>%
    dplyr::arrange(total_time) %>%
    dplyr::select(-latency_url, -test_result)

}

