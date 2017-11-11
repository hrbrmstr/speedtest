#' Test your internet speed/bandwidth
#'
#' No-frills. Picks the closest geographic server with least latency,
#' performs download & upload tests and returs the best result.
#'
#' Make a command-line alias or executable with:
#'
#' `Rscript --quiet -e 'speedtest::spd_test()'`
#'
#' @md
#' @export
#' @examples \dontrun{
#' spd_test()
#' }
spd_test <- function() {

  cat(cyan("Gathering test configuration information...\n"))
  config <- spd_config()

  cat(cyan("Gathering server list...\n"))
  servers <- spd_servers(config=config)

  cat(cyan("Determining best server...\n"))
  servers <- spd_closest_servers(servers, config)
  best <- spd_best_servers(servers, config, max=3)

  cat(green("Initiating test from ") %+% white(config$client$isp) %+% green(" (") %+%
        white(config$client$ip) %+% green(") to ") %+% white(best$sponsor[1]) %+%
        green(" (") %+% white(best$name[1]) %+% green(")\n\n"))

  cat(white$bold("Analyzing download speed"))
  down <- spd_download_test(best, config, FALSE, .progress="dots")

  cat(green("Download: ") %+% white$bold(as.integer(max(down$bw))) %+% white$bold(" Mbit/s\n"))

  cat(white$bold("\nAnalyzing upload speed"))
  up <- spd_upload_test(best, config, FALSE, .progress="dots")

  cat(green("Upload: ") %+% white$bold(as.integer(max(up$bw))) %+% white$bold(" Mbit/s\n"))

}
