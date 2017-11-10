#' Perform an upload speed/bandwidth test
#'
#' Currently, six tests are performed in increasing order of size.
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
#' @note speed/bandwidth values are in Mbits/s; these tests consume bandwidth so
#'       if you're on a metered connection, you may incur charges.
#' @export
spd_upload_test <- function(server, config=NULL, summarise=TRUE, timeout=60) {

  if (nrow(server) > 1) server <- server[1,]

  if (is.null(config)) config <- spd_config()

  up_sizes <- c(131072, 262144, 524288, 1048576, 4194304, 8388608)

  pb <- dplyr::progress_estimated(length(up_sizes))
  purrr::map(up_sizes, ~{
    pb$tick()$print()
    .dat <- sample(.base_raw, .x, replace=TRUE)
    res <- .upload_one(server$url[1], .dat, timeout)
    list(sz=.x, res=res$result)
  }) %>%
    purrr::discard(~is.null(.x$res)) %>%
    purrr::discard(~.x$res$status_code != 200) %>%
    purrr::map_df(~{
      list(
        test = "upload",
        secs = .x$res$times[6] - .x$res$times[5],
        size = .x$sz
      )
    }) %>%
    dplyr::mutate(bw = spd_compute_bandwidth(size, secs)) -> out

  if (summarise) {
    out <- dplyr::summarise(out, min=min(bw, na.rm=TRUE), mean=mean(bw, na.rm=TRUE),
                            median=median(bw, na.rm=TRUE), max=max(bw, na.rm=TRUE),
                            sd=sd(bw, na.rm=TRUE))
  }

  out$id <- server$id

  dplyr::left_join(server, out, "id")

}
