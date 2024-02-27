## code to prepare `parks_data` dataset goes here
parks_data = get_data_static()
usethis::use_data(parks_data, overwrite = TRUE)
