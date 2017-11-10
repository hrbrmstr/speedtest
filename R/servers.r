#' Retrieve a list of SpeedTest servers
#'
#' @md
#' @param config client configuration retrieved via [spd_config()]. If `NULL` it
#'        will be retrieved
#' @return data frame
#' @export
#' @examples \dontrun{
#' config <- spd_config()
#' spd_servers(config)
#' }
spd_servers <- function(config=NULL) {

  res <- httr::GET("https://www.speedtest.net/speedtest-servers-static.php")

  httr::stop_for_status(res)

  if (is.null(config)) config <- spd_config()

  httr::content(res, as="text") %>%
    read_xml() %>%
    xml2::xml_find_all(xpath="//settings/servers/server") %>%
    purrr::map_df(~{
      list(
        url = xml2::xml_attr(.x, "url") %||% NA_character_,
        lat = as.numeric(xml2::xml_attr(.x, "lat") %||% NA_real_),
        lng = as.numeric(xml2::xml_attr(.x, "lon")) %||% NA_real_,
        name = xml2::xml_attr(.x, "name") %||% NA_character_,
        country = xml2::xml_attr(.x, "country") %||% NA_character_,
        cc = xml2::xml_attr(.x, "cc") %||% NA_character_,
        sponsor = xml2::xml_attr(.x, "sponsor") %||% NA_character_,
        id = xml2::xml_attr(.x, "id") %||% NA_character_,
        host = xml2::xml_attr(.x, "host") %||% NA_character_,
        url2 = xml2::xml_attr(.x, "url2") %||% NA_character_
      )
    }) %>%
    dplyr::filter(!(id %in% config$`server-config`$ignoreids))

}
