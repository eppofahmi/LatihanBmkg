# Connect to a data source and retrieve metadata, and read a summary:
src <- tidync::tidync("data/mentah/surface_temp_indonesia_2011_2020_monthly.nc")
print(src)

# By default the largest array-space (grid) is activated and usually this will be the right choice - 
# if required we can nominate a different grid using activate().

src_slc <- src
src_slc %>% hyper_array()
src_slc %>% hyper_tibble()
src_slc %>% hyper_tbl_cube()

# install other package needed
# install.packages(c("ncmeta", "maps", "stars", "ggplot2", "devtools", "stars", "RNetCDF", "raster"))

# oisstfile <- system.file("nc/reduced.nc", package = "stars")
library(tidync)
# oisst <- tidync(oisstfile)
oisst = src

# meta data
ncmeta::nc_grids(oisstfile)
ncmeta::nc_vars(oisstfile)
ncmeta::nc_grids(oisstfile) %>% tidyr::unnest(cols = c(variables))
ncmeta::nc_dims(oisstfile)
ncmeta::nc_vars(oisstfile)
ncmeta::nc_var(oisstfile, "anom")
ncmeta::nc_var(oisstfile, 5)
ncmeta::nc_dim(oisstfile, "lon")
ncmeta::nc_dim(oisstfile, 0)
ncmeta::nc_atts(oisstfile)
ncmeta::nc_atts(oisstfile, "zlev")
ncmeta::nc_atts(oisstfile, "time") %>% tidyr::unnest(cols = c(value))

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

raster::brick(oisstfile, varname = "anom")
stars::read_stars(oisstfile)

ncmeta::nc_axes(oisstfile)

(oisst_data <- oisst %>% hyper_array())
length(oisst_data)
names(oisst_data)
dim(oisst_data[[1]])
image(oisst_data[[1]])


oisst_data <- tidync(oisstfile) %>% hyper_array()
op <- par(mfrow = n2mfrow(length(oisst_data)))
pals <- c("YlOrRd", "viridis", "Grays", "Blues")
for (i in seq_along(oisst_data)) {
  image(oisst_data[[i]], main = names(oisst_data)[i], col = hcl.colors(20, pals[i], rev = i ==1))
}
