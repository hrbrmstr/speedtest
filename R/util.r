sGET <- purrr::safely(httr::GET)
sPOST <- purrr::safely(httr::POST)


.download_one <- function(url, timeout) {
  sGET(
    url = url,
    httr::add_headers(
      `Referer` = "http://c.speedtest.net/flash/speedtest.swf",
      `Cache-Control` = "no-cache" # try to bust transparent proxy caches
    ),
    httr::user_agent(.speedtest_ua),
    httr::timeout(timeout),
    query=list(ts=as.numeric(Sys.time())) # try to bust transparent proxy caches
  )
}

.upload_one <- function(url, dat, timeout) {
  sPOST(
    url = url,
    httr::add_headers(
      `Referer` = "http://c.speedtest.net/flash/speedtest.swf",
      `Connection` = "Keep-Alive",
      `Cache-Control` = "no-cache" # try to bust transparent proxy caches
    ),
    encode="form",
    body=dat,
    httr::user_agent(.speedtest_ua),
    httr::timeout(timeout),
    query=list(ts=as.numeric(Sys.time())) # try to bust transparent proxy caches
  )
}
