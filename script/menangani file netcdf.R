# Menangangi file netCDF
# sumber: https://ropensci.org/blog/2019/11/05/tidync/

# load the ncdf4 package
library(tidyverse)
library(tidync)

# install.packages(c("ncmeta", "tidync", "maps", "stars", "ggplot2", "devtools", 
#                    "stars", "RNetCDF", "raster", "dplyr", "tidyr"))

# data 1
oisstfile <- system.file("nc/reduced.nc", package = "stars")
oisst <- tidync(oisstfile)
print(oisst) # multidimensional "D0,D1,D2,D3" memiliki 4 variabel 

# data 2
src0 = "data/mentah/surface_temp_indonesia_2011_2020_monthly.nc"
src1 <- tidync::tidync("data/mentah/surface_temp_indonesia_2011_2020_monthly.nc")
print(src1) # multidimensional "D2,D1,D0" memiliki 1 variabel: air

# eksplorasi
# Metadata in tidync: ncmeta
ncmeta::nc_grids(oisstfile)
ncmeta::nc_vars(oisstfile)

ncmeta::nc_grids(src0)
ncmeta::nc_vars(src0)

ncmeta::nc_grids(oisstfile) %>% tidyr::unnest(cols = c(variables))
ncmeta::nc_grids(src0) %>% tidyr::unnest(cols = c(variables))

ncmeta::nc_dims(oisstfile)
ncmeta::nc_dims(src0)

ncmeta::nc_var(oisstfile, "anom")
ncmeta::nc_var(src0, "air")

ncmeta::nc_atts(oisstfile, "time") %>% tidyr::unnest(cols = c(value))

# Skrip berikut tidak jalan karena perbedaan format data dalam variabel
ncmeta::nc_atts(src0, "time") %>% tidyr::unnest(cols = c(value))


# tunit <- ncmeta::nc_atts(oisstfile, "time") %>% tidyr::unnest(cols = c(value)) %>% dplyr::filter(name == "units")
# print(tunit)
# 
# tunit2 <- ncmeta::nc_atts(src0, "time") %>% tidyr::unnest(cols = c(value)) %>% dplyr::filter(name == "units")
# print(tunit2)

oisst <- tidync(oisstfile)
time_ex <- oisst %>% activate("D3") %>% hyper_array()
time_ex$time

tunit <- ncmeta::nc_atts(oisstfile, "time") %>% tidyr::unnest(cols = c(value)) %>% dplyr::filter(name == "units")
print(tunit)

time_parts <- RNetCDF::utcal.nc(tunit$value, time_ex$time)

## convert to date-time
ISOdatetime(time_parts[,"year"], 
            time_parts[,"month"], 
            time_parts[,"day"], 
            time_parts[,"hour"], 
            time_parts[,"minute"], 
            time_parts[,"second"])

as.POSIXct("1978-01-01 00:00:00", tz = "UTC") + time_ex$time * 24 * 3600

# visualisasi 
raster::brick(oisstfile, varname = "anom")
stars::read_stars(oisstfile)

ncmeta::nc_axes(oisstfile)
ncmeta::nc_dims(oisstfile)

# read data langsung
src <- tidync(src0)

(oisst_data <- oisst %>% hyper_array())
length(oisst_data)

(src_data <- src %>% hyper_array())
length(src_data)

names(oisst_data)
names(src_data)

dim(oisst_data[[1]])
dim(src_data[[1]])

image(oisst_data[[1]])
# image(src_data[[1]])

oisst_data <- tidync(oisstfile) %>% hyper_array()
op <- par(mfrow = n2mfrow(length(oisst_data)))
pals <- c("YlOrRd", "viridis", "Grays", "Blues")
for (i in seq_along(oisst_data)) {
  image(oisst_data[[i]], main = names(oisst_data)[i], col = hcl.colors(20, pals[i], rev = i ==1))
}

oisst_data2 <- tidync(src0) %>% hyper_array()
op <- par(mfrow = n2mfrow(length(oisst_data2)))
pals <- c("YlOrRd")
for (i in seq_along(oisst_data2)) {
  image(oisst_data2[[i]], main = names(oisst_data2)[i], col = hcl.colors(20, pals[i], rev = i ==1))
}
