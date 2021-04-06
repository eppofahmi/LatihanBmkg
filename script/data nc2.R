library(raster) ## requires ncdf package for this file  
d <- raster("data/mentah/surface_temp_indonesia_2011_2020_monthly.nc", varname = "air")
d <-  flip(t(d), direction = "x")
plot(d)

library(maptools)
data(wrld_simpl)
plot(wrld_simpl, add = TRUE)

library(ncdf4)
# download.file("ftp://ftp.nodc.noaa.gov/pub/data.nodc/pathfinder/Version5.2/2000/20000107010122-NODC-L3C_GHRSST-SSTskin-AVHRR_Pathfinder-PFV5.2_NOAA14_G_2000007_night-v02.0-fv01.0.nc", destfile="sst.nc")
data = ncdf4::nc_open("data/mentah/sst.nc")
sst = ncdf4::ncvar_get(data,"sea_surface_temperature")

lon = ncdf4::ncvar_get(data,"lon")
lat = ncdf4::ncvar_get(data,"lat")

data$dim$lon$vals -> lon
data$dim$lat$vals -> lat
lat <- rev(lat)
sst <- sst[,ncol(sst):1]

png(filename="plot/sst2.png",width=1215,height=607,bg="white")
image(lon, lat, sst, zlim=c(270,320), col = heat.colors(37))

image(lon,lat, sst, col=rev(brewer.pal(10,"RdBu")))
