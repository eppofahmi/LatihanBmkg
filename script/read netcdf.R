# read data 
oisstfile <- system.file("nc/reduced.nc", package = "stars")
oisst <- tidync(oisstfile)
print(oisst)
class(oisst)

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

## contoh 2
# path to file 
sumber <- "data/mentah/surface_temp_indonesia_2011_2020_monthly.nc"
ncmeta::nc_dim(sumber, "lon")
ncmeta::nc_dim(sumber, "lat")
ncmeta::nc_atts(sumber)
ncmeta::nc_atts(sumber, "time") %>% tidyr::unnest(cols = c(value))
ncmeta::nc_atts(oisstfile, "time") %>% tidyr::unnest(cols = c(value))

# read data 
sample <- tidync(sumber)
print(sample)
class(sample)

(sample_data <- sample %>% hyper_array())

length(sample_data)
names(sample_data)

dim(sample_data[[1]])
image(sample_data[[1]])


# transform
oisst_data
lapply(oisst_data, dim)

sample_data
lapply(sample_data, dim)

(trans1 <- attr(oisst_data, "transforms"))
(trans2 <- attr(sample_data, "transforms"))

image(trans1$lon$lon, trans1$lat$lat,  oisst_data[[1]])
maps::map("world2", add = TRUE)

image(trans2$lon$lon, trans2$lat$lat,  sample_data[[1]])
maps::map("world2", add = TRUE)
