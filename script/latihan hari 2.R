# setwd("Latihan BMKG 2021/")
# getwd()

# Tidyverse -> beberpa package -> terdapat bbrpa fungsi
# installasi 
# install.packages("tidyverse")

# dari github 
# install.packages("remotes")
# remotes::install_github("ropensci/tidync", dependencies = TRUE)

# memanggil
library(tidyverse)
# library(dplyr)

# Day-2 --------------------------------------------------
# 7. Jenis-jenis data yang umum digunakan
##   Vector 
cth_vector = c("ujang", "fahmi", "ulfah")

##   Data Frame/Data Flat
# rata setiap kolom memiliki baris sama
# rata setiap baris memiliki jumlah kolom sama 
vect_1 = c("ujang", "fahmi", "ulfah")
vect_2 = c(17, 15, 19)
vect_2a = c(TRUE, FALSE, FALSE)

# membuat data frame dari dua vector
df1 = data.frame(vect_1, vect_2, vect_2a, stringsAsFactors = FALSE)
class(df1)

# Untuk mengetahui tipe data dalam data frame 
glimpse(df1)

vect_3 = c("ujang", "fahmi", NA)
vect_4 = c(17, 15, 19)
df2 = data.frame(vect_3, vect_4)

##   List
vect_5 = c("ujang", "fahmi")
vect_6 = c(17, 15, 19)

# membuat list
mylist1 = list(vect_5, vect_6)

# mengakases data
## vector dengan [indeks]
vect_1[2]

## Data frame tanda $ dan []
# tanda $
df1$vect_2
df1$vect_2[2]

# tanda kotak []
df1[3,2]

## Data List tanda $ dan []
mylist1$nama_indeks

mylist1[[1]]
mylist1[1]

# targer list ke 2 data ke 2 / == fahmi
mylist1[[1]][2]

# list data frame
mylist2 = list(siswa = vect_5, 
               usia = vect_6, 
               rangkuman = df1, 
               thelist = mylist1
               )

# tanda dollar $ bisa digunakan untuk list dengan nama indeks
mylist2$usia
df3 = mylist2$rangkuman

# 8. Impor dan Ekspor Data 
##   Impor Data
# Sumber Data: https://www.kaggle.com/jsphyg/weather-dataset-rattle-package
# https://ropensci.org/blog/2019/11/05/tidync/#:~:text=There%20are%20various%20other%20packages%20for%20NetCDF%20in,tidync%20uses%20both%20to%20read%20information%20and%20data.

# impor csv
# library(readr)
?readr
datacuaca_aus = readr::read_csv(file = "data/mentah/weather AUS.csv")
# datacuaca_aus$Date = as.character(datacuaca_aus$Date)
# datacuaca_aus$Date = as.Date(x = datacuaca_aus$Date, format = "%Y-%m-%d")
glimpse(datacuaca_aus)
?read_csv

# menulis/eskpor csv
readr::write_csv(x = datacuaca_aus, path = "data/bersih/dataCuacaBersih.csv")
data2 = read_csv(file = "https://github.com/tidyverse/readr/raw/master/inst/extdata/mtcars.csv")

write_delim(x = data2, path = "data/bersih/file1.txt")
data3 = read_delim(file = "data/bersih/file1.txt", delim = " ")

tes = read_delim("https://iri.columbia.edu/~forecast/ensofcst/Data/archive/ensoforecast_data.txt", 
                 delim = " ", col_names = TRUE)

# read data excel
library(readxl)
weatherAUS <- read_excel("data/mentah/weatherAUS.xlsx", 
                         sheet = "Sheet1")

library(xlsx)
xlsx::write.xlsx(x = weatherAUS, file = "data/bersih/filxl.xlsx", sheetName = "tes1")
xlsx::write.xlsx(x = data3, file = "data/bersih/filxl.xlsx", sheetName = "tes2", append = TRUE)

# menyimpan list sebagai file rds
tes_list = list(data1 = datacuaca_aus, data2 = data3)
write_rds(x = tes_list, path = "data/bersih/tessimpanlist.rds")
data1 = read_rds(path = "data/bersih/tessimpanlist.rds")

# json
library(jsonlite)
write_json(x = tes_list, path = "data/bersih/tesjson.json")
data0 = jsonlite::read_json(path = "data/bersih/tesjson.json")

library(tidync)
datanc = tidync::tidync("data/mentah/surface_temp_indonesia_2011_2020_monthly.nc")

# Pre- Processing
library(readxl)
weatherAUS <- read_excel("data/mentah/weatherAUS.xlsx", 
                         sheet = "Sheet1")

# memilih kolom (select)
# pipe cmd/ctrl+shift+m
# target pilih kolom 2 s.d 6
obj1 = weatherAUS %>% 
  dplyr::select(2:6)

obj2 = weatherAUS %>% 
  dplyr::select(2:4, 6, 24)

obj3 = weatherAUS %>% 
  dplyr::select(Date:Rainfall, WindGustDir, 24)

# memilih baris (filter)
obj4 = weatherAUS %>% 
  dplyr::filter(MinTemp >= 20)

obj5 = weatherAUS %>% 
  dplyr::filter(MinTemp >= 15 & MinTemp <= 20)

# membuat kolom baru berdasrakan kolom yang sudah ada
obj6 = obj5 %>%
  dplyr::mutate(hujan = case_when(
    RainTomorrow == "No" ~ "Terang", 
    TRUE ~ "Hujan"
  ))

obj9 = obj8 %>% 
  pilih_kolom %>% # select() 
  pilig_baris %>% # filter()
  buat_kolom_baru # mutate()

obj7 = obj5 %>% 
  dplyr::mutate(jumlah_temp = MinTemp + MaxTemp)

library(tidyverse)
glimpse(obj7)

# filter berdasar tanggal
library(lubridate)
obj8 = obj1 %>% 
  dplyr::filter(lubridate::month(Date) == 10)