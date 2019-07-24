.download_one <- function(url, timeout) {
  sGET(
    url = url,
    httr::add_headers(
      `Referer` = "https://c.speedtest.net/flash/speedtest.swf",
      `Cache-Control` = "no-cache" # try to bust transparent proxy caches
    ),
    httr::user_agent(.speedtest_ua),
    httr::timeout(timeout),
    query = list(ts = as.numeric(Sys.time())) # try to bust transparent proxy caches
  )
}

.upload_one <- function(url, dat, timeout) {
  sPOST(
    url = url,
    httr::add_headers(
      `Referer` = "https://c.speedtest.net/flash/speedtest.swf",
      `Connection` = "Keep-Alive",
      `Cache-Control` = "no-cache" # try to bust transparent proxy caches
    ),
    encode="form",
    body = dat,
    httr::user_agent(.speedtest_ua),
    httr::timeout(timeout),
    query = list(ts = as.numeric(Sys.time())) # try to bust transparent proxy caches
  )
}

#' Convert a test speed, in Mbits/s, to its string representation along with
#' appropriate units for the magnitude of the test speed
#'
#' - Assumes number is in Mbits/s to start off with
#' - Only chooses between Kbit/s, Mbit/s, and Gbit/s
#'
#' @param number numeric The speed to be converted
#' @export
#' @return character The character representation of the speed
nice_speed <- function(number) {
  if (number < 1) {
    return(as.character(as.integer(number * 1000)) %+% " Kbit/s")
  } else if (number >= 1000) {
    return(as.character(as.integer(number / 1000)) %+% " Gbit/s")
  } else {
    return(as.character(as.integer(number)) %+% " Mbit/s")
  }
}
