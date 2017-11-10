.base_raw <- charToRaw('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')

.speedtest_ua <- "Mozilla/5.0 (Compatibe; r-speedtest/1.0; https://github.com/hrbrmstr/speedtest)"

utils::globalVariables(
  c("total", "latency_url", "test_result", "ping_time", "total_time", "retrieval_time",
    "bw", "size", "secs"))