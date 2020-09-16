## code to prepare `sampledat` dataset goes here
library(tidyverse)
# make sampledat from fitted model
# assumes an input file with the fitted values in the cases column.
sampledat <- readr::read_csv("data-raw/predictionsthrough2018.csv")
# # should only need to do this once, then write back to data-raw file
# # fix arthur county with bayesian posterior for 16 samples of 0 from a poisson distribution
# # given a 1, 1 gamma prior we have gamma(1, 17) as the posterior. This
# # still has a probability 0.52 of observing 16 zeros at the median.
# # So the median is 0.04077336
# sampledat <- dplyr::bind_rows(sampledat, dplyr::tibble(year = 2002:2019,
#                              County = "Arthur",
#                              cases = 0.0477336)) %>%
#   mutate(County = case_when(County == "KeyaPaha" ~ "Keya Paha",
#                             County == "BoxButte" ~ "Box Butte",
#                             County == "ScottsBluff" ~ "Scotts Bluff",
#                             County == "RedWillow" ~ "Red Willow",
#                             TRUE ~ County),
#          location = paste("Nebraska",County, sep = "-"))
# # need to add the fips code
# # use the census data from wnvdata
# library(wnvdata)
# data("census.data")
# #anti_join(sampledat, census.data, by = "location")
# sampledat <- census.data %>%
#   filter(year == 2019) %>%
#   select(location, fips) %>%
#   right_join(sampledat, by = "location") %>%
# rename(expected_cases = cases)
# write_csv(sampledat, "data-raw/predictionsthrough2018.csv")
usethis::use_data(sampledat, overwrite = TRUE)

