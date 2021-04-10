# install.packages("ncdf4")
# install.packages("RNetCDF")

library(tidyverse)
library(tidync)

# file <- system.file("extdata", "oceandata", "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc", package = "tidync")
# tes_nc = tidync(file) 
# 
# filename <- system.file("extdata/argo/MD5903593_001.nc", package = "tidync")
# ## discover the available entities, and the active grid's dimensions and variables
# tidync(filename)
# glimpse(filename)
# 
# grid_identifier <- "D7,D9,D11,D8"
# tidync(filename) %>% activate(grid_identifier)
# 
# (subs <- tidync(filename) %>% hyper_filter(N_PROF = N_PROF > 1, STRING256 = index > 10))
# 
# df = subs %>% hyper_tibble()
# 
# subs %>% hyper_tbl_cube(select_var = c("PRES", "PRES_QC", "PSAL_ADJUSTED"))
# 
# df %>% dplyr::filter(longitude > 100, longitude < 150)
# tidync(filename) %>% hyper_filter(longitude = longitude > 100 & longitude < 150)

# data dari mas andhika
datanc = tidync::tidync("data/mentah/surface_temp_indonesia_2011_2020_monthly.nc")
glimpse(datanc)
