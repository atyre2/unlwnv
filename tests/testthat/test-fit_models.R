data(sampledat)
test_that("data checks work", {
  expect_error(fit_models(x = NULL), "x must be a data frame")
  expect_error(fit_models(x = sampledat, path_2_case_data = "almostcertainlynotavalidfile"),
               "Please provide a valid path to the WNV case data.")
})

test_that("return value valid", {
  expect_type(fit_models(x = sampledat, path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
                         case_variable = "expected_cases",
                         measure = "precip",
                         nUnits = 24,
                         startUnit = 7,
                         unit = "month.num"),
              "list")
})

test_fits <- fit_models(x = sampledat[1:10,],
                           path_2_case_data = here::here("data-raw/predictionsthrough2018.csv"),
                           case_variable = "expected_cases",
                           measure = c("precip", "mean_temp", "precip"),
                           nUnits = c(24, 24, 18),
                           startUnit = 7,
                           unit = "month.num")
