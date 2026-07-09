test_that("converting lav_string works", {
  expect_equal(lav_string("fac1", c("item1", "item2", "item3", "item4")),
               "fac1 =~ item1 + item2 + item3 + item4")
  expect_equal(lav_string("fac1", c("item.n")),
               "fac1 =~ item.n")
})

test_that("converting lav_string_tau works", {
  expect_equal(lav_string_tau("fac1", c("item1", "item2", "item3", "item4")),
               "fac1 =~ 1*item1 + 1*item2 + 1*item3 + 1*item4")
  expect_equal(lav_string_tau("fac1", c("item.n")),
               "fac1 =~ 1*item.n")
})


# test_file("C:/Users/s6yee/OneDrive - University of Waterloo/Lab/Shawn/elfs/elfs/tests/testthat/test-elfs.R")
