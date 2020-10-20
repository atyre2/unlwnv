data(sampledat)

# library(tidyverse)
# # make a broken data set for testing
# broken_cases <- readr::read_csv(here::here("data-raw/predictionsthrough2018.csv"))
# # missing one county
# broken_cases %>%
#   filter(year == 2002, County != "Adams") %>%
#   write_csv(path = here::here("tests/testthat/data/missing_one_county.csv"))
#
# # missing fips
# broken_cases %>%
#   select(-fips) %>%
#   write_csv(path = here::here("tests/testthat/data/missing_fips.csv"))

test_that("data checks work", {
  expect_error(assemble_data(x = NULL), "x must be a data frame")
  expect_error(assemble_data(x = sampledat[1:10, ], path_2_case_data = "almostcertainlynotavalidfile"),
               "Please provide a valid path to the WNV case data.")
  expect_error(assemble_data(x = sampledat[1:10,],
                             path_2_case_data = here::here("tests/testthat/data/missing_one_county.csv"),
                             case_variable = "expected_cases"),
               "Some prediction targets have no matches in case data.")
  expect_error(assemble_data(x = sampledat[1:10,], path_2_case_data = here::here("tests/testthat/data/missing_fips.csv")),
               regexp = "^match variable\\(s\\) \\S* not found in file")
  expect_error(assemble_data(x = sampledat[1:10,], path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
                             case_variable = "expected_cases",
                             case_type = "foobar"),
               regexp = "'arg' should be one of \"neuro\", \"all\"")
})

test_that("return value valid", {
  expect_s3_class(assemble_data(x = sampledat[1:10,],
                            path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
                            case_variable = "expected_cases",
                            measure = "precip",
                            nUnits = 24,
                            startUnit = 7,
                            unit = "month.num"), "data.frame")
})

test_data <- assemble_data(x = sampledat[1:10,],
              path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
              case_variable = "expected_cases",
              measure = c("precip", "mean_temp", "precip"),
              nUnits = c(24, 24, 18),
              startUnit = 7,
              unit = "month.num")

test_that("multiple lags works properly", {
  expect_s3_class(test_data, "data.frame")
  expect_named(test_data, c("Location", "fips", "County", "year", "fit", "se", "expected_cases",
                            "district_year", "POP", "lag_7_24", "precip_7_24","mean_temp_7_24","precip_7_18"))
})
