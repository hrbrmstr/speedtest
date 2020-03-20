#' Perform an official Ookla Speed Test via their command line tools
#'
#' @export
speedtest_cli <- function(progress = TRUE) {

  spdtst <- Sys.which(c("speedtest", "speedtest.exe"))
  spdtst <- spdtst[spdtst != ""]

  if (length(spdtst) == 0) {
    stop(
      "speedtest cli executable not found. ",
      "Use install_speedtest_cli() to install it.",
      call. = FALSE
    )
  }

  progress <- if (progress[1]) "yes" else "no"
  progress <- sprintf("--progress=%s", progress)

  args <- c(progress, "--format=jsonl")

  system2(
    spdtst,
    args = args,
    TRUE
  ) -> res

  res <- lapply(res, jsonlite::fromJSON)

  download <- list()
  upload <- list()
  result <- list()

  for (.x in res) {

    if (.x$type == "download") {
      download <- append(download, list(.x))
    } else if (.x$type == "upload") {
      upload <- append(upload, list(.x))
    } else {
      result <- append(result, list(.x))
    }

  }

  list(
    download = dplyr::bind_rows(lapply(download, dplyr::as_tibble)),
    upload = dplyr::bind_rows(lapply(upload, dplyr::as_tibble)),
    result = result
  ) -> res

  class(res) <- c("speedtest_cli_result")

  res

}

#' @rdname speedtest_cli
#' @param x `speedtest_cli_result` object
#' @param browse if `TRUE`, open a browser window with the results
#' @param ... ignored
#' @export
print.speedtest_cli_result <- function(x, browse = FALSE, ...) {

  fmt <- scales::label_number_si(accuracy = 0.001, unit = "")

  cat(
    "Provider: ", x$result[[7]]$isp, "\n",
    "    Ping: ", x$result[[7]]$ping$latency, " ms\n",
    "Download: ", fmt(x$result[[7]]$download$bytes), "\n",
    "  Upload: ", fmt(x$result[[7]]$upload$bytes), "\n",
    "     URL: ", x$result[[7]]$result$url,
    sep = ""
  )

  if (browse) utils::browseURL(x$result[[7]]$result$url)

}
