#' Fit all the models and return a list object suitable for DFMIP.
#'
#' @param x tibble or data frame that defines the desired prediction targets. Must have at least a FIPS code and year.
#' @param path_2_case_data character file path to the case data
#' @param case_type character type of case data
#' @param case_variable character name of the case field in the case data
#' @param match_variable character name of the field to match data on
#'
#' @details This function uses the rows in x to define the prediction
#' targets for the models. There must be at least two fields, the 5 digit fips code
#' to identify the county as a character variable and a year numeric variable to
#' identify the year.
#'
#' The WNV case data cannot be posted publicly as a part of this package. This package
#' assumes the case data are available in a subdirectory of the working directory
#' called `data-raw`, in a file called `wnv_by_county.csv` which has rows
#' identified by the same fips codes and a year variable. Case counts are assumed
#' to be in a variable called "cases". There must be at least one row for each
#' fips code in `x`.
#'
#'
#' @return a list of containing predicted cases for the target in the format expected by `DFMIP`
#' @export
fit_models <- function(x, path_2_case_data = here::here("data-raw/wnv_by_county.csv"),
                       case_type = c("neuro", "all"),
                       match_variable = "fips",
                       case_variable = "cases"){
  fit_data <- assemble_data(x = x, path_2_case_data = path_2_case_data,
                            case_type = case_type,
                            match_variable = match_variable,
                            case_variable = case_variable)
  return(list())
}
