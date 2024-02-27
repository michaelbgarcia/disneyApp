## code to prepare `parks_ref` dataset goes here
parks_ref = get_data_parks()
usethis::use_data(parks_ref, overwrite = TRUE)
