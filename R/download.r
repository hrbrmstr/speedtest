#' Download test
#'
#' @export
spd_download_test <- function(server, config=NULL) {

  if (nrow(server) > 1) server <- server[1,]

  server <- unclass(server)

  down_sizes <- c(350, 500, 750, 1000, 1500, 2000, 2500, 3000, 3500, 4000)

  dl_urls <- sprintf("%s/random%sx%s.jpg", dirname(server$url), down_sizes, down_sizes)

  pb <- dplyr::progress_estimated(length(dl_urls))
  purrr::map(dl_urls, ~{
    pb$tick()$print()
    httr::GET(
      url = .x,
      httr::add_headers(
        `Referer` = "http://c.speedtest.net/flash/speedtest.swf",
        `Cache-Control` = "no-cache"
      ),
      httr::user_agent(
        splashr::ua_macos_chrome
      ),
      query=list(ts=as.numeric(Sys.time()))
    )
  }) -> dl_resp

  purrr::discard(dl_resp, ~.x$status_code != 200) %>%
  purrr::map_df(~{
    list(secs = .x$times[6] - .x$times[5], size = (length(.x$content) + length(.x$header)))
  }) %>%
  dplyr::mutate(bw = ((size/secs)*8) / 1024 / 1024) %>%
  dplyr::summarise(min=min(bw), mean=mean(bw), median=median(bw), max=max(bw), sd=sd(bw), var=var(bw))

}
