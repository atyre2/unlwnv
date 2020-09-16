
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
#'
#' @return a data.frame ready to estimate distributed lag models
#' @export
#'
assemble_data <- function(x, path_2_case_data = here::here("data-raw/wnv_by_county.csv"),
                          case_type = c("neuro", "all"),
                          match_variable = "fips",
                          case_variable = "cases"
){
  if(is.null(x) | !(is.data.frame(x) | tibble::is_tibble(x))){
    stop("x must be a data frame or tibble.")
  }
  if(!file.exists(path_2_case_data)){
    stop("Please provide a valid path to the WNV case data.")
  } else {
    wnvcases <- readr::read_csv(path_2_case_data)
    mv1 <- eval(quote(match_variable), wnvcases)
    mv2 <- eval(quote(match_variable), x)
    # check that all targets exist in case data
    missing_targets <- dplyr::anti_join(x, wnvcases, by = match_variable)
    if (nrow(missing_targets) > 0){
      stop("Some prediction targets have no matches in case data.")
    }
  }
  return(wnvcases)
}
