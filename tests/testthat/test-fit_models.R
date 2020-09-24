data(sampledat)
test_that("data checks work", {
  expect_error(fit_models(x = NULL), "x must be a data frame or tibble.")
  expect_error(fit_models(x = sampledat, path_2_case_data = "almostcertainlynotavalidfile"),
               "Please provide a valid path to the WNV case data.")
})

test_that("return value valid", {
  expect_type(fit_models(x = sampledat, path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
                         case_variable = "expected_cases",
                         measure = "ppt",
                         nUnits = 24,
                         startUnit = 7,
                         unit = "months"),
              "list")
})
