.base_raw <- charToRaw('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')

.speedtest_ua <- "Mozilla/5.0 (Compatible; r-speedtest/1.0; https://gitlab.com/hrbrmstr/speedtest)"

utils::globalVariables(
  c(
    "total", "latency_url", "test_result", "ping_time", "total_time",
    "retrieval_time", "bw", "size", "secs", "id"
  )
)

sGET <- purrr::safely(httr::GET)
sPOST <- purrr::safely(httr::POST)
