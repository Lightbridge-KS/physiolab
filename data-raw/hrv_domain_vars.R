## code to prepare `hrv_domain_vars` dataset goes here

hrv_domain_vars <- list(time = c("SDNN", "SD_del_NN", "RMSSD", "Normals_count",
                                 "NN50_count", "NN50_percent"),
                        freq = c("Power_tot", "VLF_freq","VLF",
                                 "LF_freq","LF", "LF_nu",
                                 "HF_freq","HF", "HF_nu",
                                 "LF_HF")
)

usethis::use_data(hrv_domain_vars, overwrite = TRUE)
