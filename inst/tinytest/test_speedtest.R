library(speedtest)

# speeds are displayed in appropriate units
expect_true(grepl("Kbit/s", nice_speed(0.1)))
expect_true(grepl("Mbit/s", nice_speed(1)))
expect_true(grepl("Gbit/s", nice_speed(1000)))

expect_true(all(c("client", "odometer") %in% names(spd_config())))
