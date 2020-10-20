
#' Assemble WNV data for analysis
#'
#' This function pulls together all the different datasets from
#' package `wnvdata` and the local case data. Some basic consistency
#' checks are performed.
#'
#' @param x a data.frame or tibble with the prediction targets
#' @param path_2_case_data character file path to the case data
#' @param case_type character type of case data
#' @param case_variable character name of the case field in the case data
#' @param match_variable character name of the field to match data on
#' @param measure character vector of variables to use for lagging
#' @param nUnits integer vector of number of units to lag backwards
#' @param startUnit integer unit to start lagging from
#' @param unit character name of the variable identifying the lag units
#'
#' @return a data.frame ready to estimate distributed lag models
#' @export
#'
assemble_data <- function(x, path_2_case_data = here::here("data-raw/wnv_by_county.csv"),
                          case_type = c("neuro", "all"),
                          match_variable = "fips",
                          case_variable = "cases",
                          measure = NULL,
                          nUnits = NULL,
                          startUnit = NULL,
                          unit = NULL){
  if(is.null(x) | !is.data.frame(x) ){
    stop("x must be a data frame")
  }
  if(!file.exists(path_2_case_data)){
    stop("Please provide a valid path to the WNV case data.")
  } else {
    wnvcases <- readr::read_csv(path_2_case_data)
    # force to be a dataframe
    wnvcases <- as.data.frame(wnvcases)
    check_match <- match(match_variable,names(wnvcases))
    if(any(is.na(check_match))){
      stop(sprintf("match variable(s) %s not found in file %s",
                   match_variable[is.na(check_match)],
                   path_2_case_data))
    }
    if(!case_variable %in% names(wnvcases)){
      stop(sprintf("case variable %s not found in file %s", case_variable, path_2_case_data))
    }
    if("fips" %in% names(wnvcases)){
      # force fips to be 5 digit character
      wnvcases[["fips"]] <- sprintf("%05d", as.numeric(wnvcases[["fips"]]))
    }
    # check that all targets exist in case data
    missing_targets <- dplyr::anti_join(x, wnvcases, by = match_variable)
    if (nrow(missing_targets) > 0){
      stop("Some prediction targets have no matches in case data. ")
    }
  }
  case_type = match.arg(case_type)
  # check lag arguments
  args <- as.list(environment())
  nulls <- purrr::map_lgl(args, is.null)
  if(any(nulls)){
    stop(glue::glue("{paste(names(args[nulls]), collapse=\", \")} must have values provided. "))
  }


  # bind census data
  data(census.data, package = "wnvdata")
  fit_data <- dplyr::left_join(wnvcases, census.data, by = c(match_variable, "year"))

  # make lags
  data(conus_weather, package = "wnvdata")
  # rename location -> Location for flmtools
  conus_weather <- dplyr::rename(conus_weather, Location = location)
  fit_data <- dplyr::rename(fit_data, Location = location.x)
  fit_data <- dplyr::select(fit_data, -location.y)
  # force to be data.frame
  conus_weather <- as.data.frame(conus_weather)

  if (length(nUnits)!=length(measure)){
    if(length(nUnits)==1) nUnits <- rep(nUnits, times = length(measure))
    else{
      stop("nUnits must be length 1 or length(measure).")
    }
  }
  tmp_data <- list()
  for (i in seq_along(measure)){
    tmp_data[[i]] <- flmtools::lagData(conus_weather, fit_data,
                                  unit = unit, startUnit = startUnit,
                                  nUnits = nUnits[i], measure = measure[i])
  }
  original_ncols <- ncol(fit_data)
  lagMatName <- names(tmp_data[[1]])[original_ncols+2] # probably brittle
  fit_data[,lagMatName] <- tmp_data[[1]][, lagMatName]
  for (i in seq_along(measure)){
    byMatName <- names(tmp_data[[i]])[original_ncols+1]
    fit_data[, byMatName] <- tmp_data[[i]][, byMatName]
  }
  return(fit_data)
}
