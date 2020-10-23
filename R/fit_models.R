#' Fit all the models and return a list object suitable for DFMIP.
#'
#' @param x tibble or data frame that defines the desired prediction targets. Must have at least a FIPS code and year.
#' @param path_2_case_data character file path to the case data
#' @param case_type character type of case data
#' @param case_variable character name of the case field in the case data
#' @param match_variable character name of the field to match data on
#' @param measure character vector of variables to use for lagging
#' @param nUnits integer number of units to lag backwards
#' @param startUnit integer unit to start lagging from
#' @param unit character name of the variable identifying the lag units
#' @param models list of formulas for to use. No checks are performed to ensure the formulas are consistent with other arguments.
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
                       case_variable = "cases",
                       measure = NULL,
                       nUnits = NULL,
                       startUnit = NULL,
                       unit = NULL,
                       models = NULL){
  case_type = match.arg(case_type)
  fit_data <- assemble_data(x = x, path_2_case_data = path_2_case_data,
                            case_type = case_type,
                            match_variable = match_variable,
                            case_variable = case_variable,
                            measure = measure,
                            nUnits = nUnits,
                            startUnit = startUnit,
                            unit = unit)
  if(is.null(models)){
    warning("Using default model set.")
    models = list(~offset(log(population)) + CI + s(lag_7_24, by = precip_7_24),
                  ~offset(log(population)) + CI + s(lag_7_24, by = mean_temp_7_24))
    models = purrr::map(models, update, new = paste0(case_variable," ~ ."))
  }
  fits <- purrr::map(models, gam, family = "nb", data = fit_data)
  return(fits)
}
