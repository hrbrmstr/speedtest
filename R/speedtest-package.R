#' Tools to Test and Compare Internet Bandwidth Speeds
#'
#' The 'Ookla' 'Speedtest' site <https://beta.speedtest.net/about> provides
#' interactive and programmatic services to test and compare bandwidth speeds
#' from  a source node on the Internet to thousands of test servers. Tools are
#' provided to obtain test server lists, identify target servers for testing and
#' performing speed/bandwidth tests.
#'
#' @md
#' @name speedtest
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr xml2 httr cli crayon
#' @importFrom utils globalVariables browseURL
#' @importFrom tibble tibble
#' @importFrom dplyr left_join arrange filter select summarise mutate
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl_fetch_multi multi_run
#' @importFrom pingr ping
#' @importFrom urltools domain
#' @importFrom stats median sd
#' @importFrom scales label_number_si
"_PACKAGE"
