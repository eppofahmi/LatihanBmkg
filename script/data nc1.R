# mengelola data .nc
library(tidyverse)
library(ncdf4)
library(ncdf4.helpers)

# Impor data
# set path and filename
ncpath <- "data/mentah/"
ncname <- "surface_temp_indonesia_2011_2020_monthly.nc"  
ncfname <- paste0(ncpath, ncname)
dname <- "air"  # note: tmp means temperature (not temporary)

# open a netCDF file
ncin <- nc_open(ncfname)
class(ncin)
print(ncin)

# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)

lat <- rev(ncvar_get(ncin,"lat")) # lat harus diubah hingga dari kecil ke besar 
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat))

# get time
time <- ncvar_get(ncin,"time")
time

tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt
tunits

# get temperature
tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(tmp_array)

# get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

ls()

# load some packages
library(chron)
library(lattice)
library(RColorBrewer)

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
chron(time,origin=c(tmonth, tday, tyear))

# replace netCDF fill values with NA's
tmp_array[tmp_array==fillvalue$value] <- NA
length(na.omit(as.vector(tmp_array[,,1])))

# get a single slice or layer (January)
m <- 2
tmp_slice <- tmp_array[,,m]
# quick map
image(lon,lat, tmp_slice, col=rev(brewer.pal(10,"RdBu")))

# levelplot of the slice
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))


# create dataframe -- reshape data
# matrix (nlon*nlat rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of `tmp` values
tmp_vec <- as.vector(tmp_slice)
length(tmp_vec)

# create dataframe and add names
tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
head(na.omit(tmp_df01), 10)

# set path and filename
csvpath <- "data/mentah"
csvname <- "cru_tmp_1.csv"
csvfile <- paste(csvpath, csvname, sep="")
write.table(na.omit(tmp_df01),csvfile, row.names=FALSE, sep=",")

# reshape the array into vector
tmp_vec_long <- as.vector(tmp_array)
length(tmp_vec_long)

# reshape the vector into a matrix
tmp_mat <- matrix(tmp_vec_long, nrow=nlon*nlat, ncol=nt)
dim(tmp_mat)
head(na.omit(tmp_mat))

# create a dataframe
lonlat <- as.matrix(expand.grid(lon,lat))
tmp_df02 <- data.frame(cbind(lonlat,tmp_mat))
names(tmp_df02) <- c("lon","lat","tmpJan","tmpFeb","tmpMar","tmpApr","tmpMay","tmpJun",
                     "tmpJul","tmpAug","tmpSep","tmpOct","tmpNov","tmpDec")
# options(width=96)
head(na.omit(tmp_df02, 12))

# get the annual mean and MTWA and MTCO
tmp_df02$mtwa <- apply(tmp_df02[3:14],1,max) # mtwa
tmp_df02$mtco <- apply(tmp_df02[3:14],1,min) # mtco
tmp_df02$mat <- apply(tmp_df02[3:14],1,mean) # annual (i.e. row) means
head(na.omit(tmp_df02))

dim(na.omit(tmp_df02))

# write out the dataframe as a .csv file
csvpath <- "data/mentah/"
csvname <- "cru_tmp_2.csv"
csvfile <- paste(csvpath, csvname, sep="")
write.table(na.omit(tmp_df02),csvfile, row.names=FALSE, sep=",")

# create a dataframe without missing values
tmp_df03 <- na.omit(tmp_df02)
head(tmp_df03)

ls()

# data frame to array -----
# time an R process 
ptm <- proc.time() # start the timer
# ... some code ...
proc.time() - ptm # how long?

# copy lon, lat and time from the initial netCDF data set
lon2 <- lon
lat2 <- lat
time2 <- time
tunits2 <- tunits
nlon2 <- nlon; nlat2 <- nlat; nt2 <- nt

# generate lons, lats and set time
lon2 <- as.array(seq(-179.75,179.75,0.5))
nlon2 <- 720
lat2 <- as.array(seq(-89.75,89.75,0.5))
nlat2 <- 360
time2 <-as.array(c(27773.5, 27803.5, 27833.5, 27864.0, 27894.5, 27925.0,
                   27955.5, 27986.5, 28017.0, 28047.5, 28078.0, 28108.5))
nt2 <- 12
tunits2 <- "days since 1900-01-01 00:00:00.0 -0:00"

# Reshaping a “full” data frame to an array
ptm <- proc.time() # start the timer
# convert tmp_df02 back into an array
tmp_mat2 <- as.matrix(tmp_df02[3:(3+nt-1)])
dim(tmp_mat2)

# then reshape the array
tmp_array2 <- array(tmp_mat2, dim=c(nlon2,nlat2,nt))
dim(tmp_array2)

# convert mtwa, mtco and mat to arrays
mtwa_array2 <- array(tmp_df02$mtwa, dim=c(nlon2,nlat2))
dim(mtwa_array2)

mtco_array2 <- array(tmp_df02$mtco, dim=c(nlon2,nlat2))
dim(mtco_array2)

mat_array2 <- array(tmp_df02$mat, dim=c(nlon2,nlat2))
dim(mat_array2)

# some plots to check creation of arrays
library(lattice)
library(RColorBrewer)

levelplot(tmp_array2[,,1] ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))), main="Mean July Temperature (C)")

levelplot(mtwa_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTWA (C)")
levelplot(mtco_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTCO (C)")
levelplot(mat_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))), main="MAT (C)")

#full tutorial: https://pjbartlein.github.io/REarthSysSci/netCDF.html