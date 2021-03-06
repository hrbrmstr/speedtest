#' Provides instructions for installing the official speedtest CLI application
#'
#' @export
install_speedtest_cli <- function() {

  utils::browseURL("https://www.speedtest.net/apps/cli")

  warning(
    "You will need to run speedtest once manually so you ",
    "can accept the Ookla license. Failure to do so will ",
    "result in errors generated by the use of speedtest_cli().",
    call. = FALSE
  )

}