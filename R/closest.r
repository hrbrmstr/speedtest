#' Find "closest" servers (geography-wise) from master server list
#'
#' @md
#' @param servers if not `NULL`, then the data frame from [spd_servers()]. If
#'        `NULL`, then [spd_servers()] will be called to retrieve the server list.
#' @param config client configuration retrieved via [spd_config()]. If `NULL` it
#'        will be retrieved
#' @return server list in order of geographic closeness
#' @export
#' @examples \dontrun{
#' spd_closest_servers()
#' }
spd_closest_servers <- function(servers=NULL, config=NULL) {

  if (is.null(config)) config <- spd_config()

  if (is.null(servers)) servers <- spd_servers(config)

  # we don't need great circle for this, just best effort
  idx <- order(sqrt((servers$lat - as.numeric(config$client$lat))^2 +
                      (servers$lng - as.numeric(config$client$lon))^2))

  servers[idx,]

}

