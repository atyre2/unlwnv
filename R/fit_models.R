#' Fit all the models and return a list object suitable for DFMIP.
#'
#' @param x tibble or data frame that defines the desired prediction targets. Must have at least a FIPS code and year.
#' @param path_2_case_data character file path to the case data
#' @param case_type character type of case data
#' @param case_variable character name of the case field in the case data
#'
#' @details This function uses the rows in x to define the prediction
#' targets for the models. There must be at least two fields, the 5 digit fips code
#' to identify the county as a character variable and a year numeric variable to
#' identify the year.
#'
#' The WNV case data cannot be posted publicly as a part of this package. This package
#' assumes the case data are available in a subdirectory of the working directory
#' called `data-raw`, which has rows
#' identified by the same fips codes and a year variable. Case counts are assumed
#' to be in a variable called "cases". There must be at least one row for each
#' fips code in `x`.
#'
#'
#' @return a list of containing predicted cases for the target in the format expected by `DFMIP`
#' @export
fit_models <- function(x, path_2_case_data = here::here("data-raw/wnv_by_county.csv"),
                       case_type = c("neuro", "all"),
                       case_variable = "cases"){
  if(is.null(x) | !is.data.frame(x) | !tibble::is_tibble(x)){
    stop("x must be a data frame or tibble.")
  }
  if(!file.exists(path_2_case_data)){
    stop("Please provide a valid path to the WNV case data.")
  }
  return(list())
}
