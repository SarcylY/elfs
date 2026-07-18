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

test_that("general model fit works", {
  nfc_data <- elfs::NeedforCognition_HusseyHughes_data
  nfc_elfs <- elfs(data = nfc_data, f1_cols = starts_with("nfc"), f1_name = "NFC",
                   chrome_bypass = T)

  #testing model chi-square
  expect_equal(round(nfc_elfs$summary$fit["chisq"], 3),
               4110.060,
               ignore_attr = T)
})

test_that("general dynamic fit works", {
  #skipping on cran due to long runtime for dynamic
  skip_on_cran()

  #generating elfs data from nfc dataset
  nfc_data <- elfs::NeedforCognition_HusseyHughes_data
  nfc_elfs <- elfs(data = nfc_data, f1_cols = starts_with("nfc"), f1_name = "NFC",
                   dynamic = T,
                   chrome_bypass = T)

  #testing close sense chisq
  expect_equal(round(as.numeric(nfc_elfs$dynamic$cutoffs[4,3]), 3),
               0.933,
               ignore_attr = T)

  #testing fair sense chisq
  expect_equal(round(as.numeric(nfc_elfs$dynamic$cutoffs[7,3]), 3),
               0.892,
               ignore_attr = T)

  #testing mediocre sense chisq
  expect_equal(round(as.numeric(nfc_elfs$dynamic$cutoffs[10,3]), 3),
               0.849,
               ignore_attr = T)
})

# #testing H
# expect_equal(round(nfc_elfs$summary$fit["chisq"], 3),
#              4110.060,
#              ignore_attr = T)
#
# #testing omega
# expect_equal(round(nfc_elfs$summary$fit["chisq"], 3),
#              4110.060,
#              ignore_attr = T)
#
# #testing AVE
# expect_equal(round(nfc_elfs$summary$fit["chisq"], 3),
#              4110.060,
#              ignore_attr = T)

# test_file("C:/Users/s6yee/OneDrive - University of Waterloo/Lab/Shawn/elfs/elfs/tests/testthat/test-elfs.R")
