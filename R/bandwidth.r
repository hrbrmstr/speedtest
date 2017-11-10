#' Compute bandwidth from bytes transferred and time taken
#'
#' @md
#' @param size_bytes size (in bytes) of the payload transferred
#' @param xfer_secs time taken for the transfer
#' @param mbits produce output in megabits (Mb)? Default: `TRUE`
#' @export
#' @examples
#' spd_compute_bandwidth(19200000, 1) # 150 Mb/sec
spd_compute_bandwidth <- function(size_bytes, xfer_secs, mbits=TRUE) {
  res <- size_bytes / xfer_secs
  if (mbits) res <- (res*8) / 1024 / 1000
  res
}
