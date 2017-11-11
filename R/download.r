#' Perform a download speed/bandwidth test
#'
#' Currently, ten tests are performed in increasing order of size.
#'
#' This uses the legacy HTTP method of determining your bandwidth/speed and,
#' as such, has many issues. Rather than hack-compensate for error-prone
#' results with smaller files used on high-bandwidth connections, raw size +
#' transfer speed data is returned enabling you to perform your own adjustments
#' or choose which values to "believe".
#'
#' @md
#' @param server a data frame row from one of the functions that retrieves or
#'        filters a server list. You can pass in a full servers list but
#'        only the first entry will be processed.
#' @param config client configuration retrieved via [spd_config()]. If `NULL` it
#'        will be retrieved
#' @param summarise the raw results from each test --- including file sizes ---
#'        will be returned if the value is `FALSE`. If `TRUE` only summary
#'        statistics will be returned.
#' @param timeout max time (seconds) to wait for a connection or download to finish.
#'        Default is `60` seconds
#' @param .progress if "`dplyr`" then `dplyr` progress bars will be used. If
#'        "`dot`" then "`.`" will be used. If anything else or "`none`", then
#'        no progress will be reported.
#' @note speed/bandwidth values are in Mbits/s; these tests consume bandwidth so
#'       if you're on a metered connection, you may incur charges.
#' @export
#' @examples \dontrun{
#' config <- spd_config()
#'
#' servers <- spd_servers(config=config)
#' closest_servers <- spd_closest_servers(servers, config=config)
#' only_the_best_severs <- spd_best_servers(closest_servers, config)
#'
#' spd_download_test(closest_servers, config=config)
#' spd_download_test(best_servers, config=config)
#' }
spd_download_test <- function(server, config=NULL, summarise=TRUE, timeout=60, .progress="dplyr") {

  if (nrow(server) > 1) server <- server[1,]

  if (is.null(config)) config <- spd_config()

  down_sizes <- c(350, 500, 750, 1000, 1500, 2000, 2500, 3000, 3500, 4000)

  dl_urls <- sprintf("%s/random%sx%s.jpg", dirname(server$url[1]), down_sizes, down_sizes)

  if (.progress == 'dplyr') pb <- dplyr::progress_estimated(length(dl_urls))

  purrr::map(dl_urls, ~{
    if (.progress == 'dplyr') pb$tick()$print()
    if (.progress == 'dots') cat(".", sep="")
    res <- .download_one(url=.x, timeout=timeout)
    res$result
  }) %>%
    purrr::discard(is.null) %>%
    purrr::discard(~.x$status_code != 200) %>%
    purrr::map_df(~{
      list(
        test = "download",
        secs = .x$times[6] - .x$times[5],
        size = sum(purrr::map_dbl(names(unlist(.x$all_headers)), nchar)) +
          sum(purrr::map_dbl(unlist(.x$all_headers), nchar)) + length(.x$content)
      )
    }) %>%
    dplyr::mutate(bw = spd_compute_bandwidth(size, secs)) -> out

  if (.progress == 'dots') cat("\n", sep="")

  if (summarise) {
    out <- dplyr::summarise(out, min=min(bw, na.rm=TRUE), mean=mean(bw, na.rm=TRUE),
                            median=median(bw, na.rm=TRUE), max=max(bw, na.rm=TRUE),
                            sd=sd(bw, na.rm=TRUE))
  }

  out$id <- server$id

  dplyr::left_join(server, out, "id")

}
