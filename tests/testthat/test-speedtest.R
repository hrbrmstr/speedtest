context("basic functionality")
test_that("we can do something", {

  #expect_that(some_function(), is_a("data.frame"))

})

test_that("speeds are displayed in appropriate units", {
  expect_match(nice_speed(0.1), "Kbit/s")
  expect_match(nice_speed(1), "Mbit/s")
  expect_match(nice_speed(1000), "Gbit/s")
})