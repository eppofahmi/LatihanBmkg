# Day3 - Pre-processing
library(tidyverse)

# load/impor data
weatherAUS = read_csv("data/mentah/weather AUS.csv")
glimpse(weatherAUS)

# memilih kolom (select)
# pipe cmd/ctrl+shift+m
# target pilih kolom 2 s.d 6
obj1 = weatherAUS %>%
  dplyr::select(2:6) # kolom ke-2 sampai ke-6

obj1 = weatherAUS %>%
  dplyr::select(c(2:6, 9)) # kolom ke-2 sampai ke-6 dan 9

glimpse(obj1)

obj2 = weatherAUS %>%
  dplyr::select(2:4, 6, 23)

# untuk mengetahui nama2 kolom dalam sebuah data frame/tabel
colnames(x = weatherAUS)

# menggunakan nama kolom dan indeks/nomor kolom
obj3 = weatherAUS %>%
  dplyr::select(Date:Rainfall, WindGustDir, 23)
glimpse(weatherAUS)

# pilih kolom berdasarkan regular expression/pola
obj4 = weatherAUS %>%
  select(Date, contains("Temp"))
glimpse(obj4)

obj5 = weatherAUS %>%
  select(Date, Location, contains("Wind"))

obj5 = weatherAUS %>%
  select(Date, Location, starts_with("Wind"))

glimpse(weatherAUS)
glimpse(obj5)

# manipulasi value sebuah variabel
obj6 = obj5 %>%
  mutate(
    WindGustDir = case_when(
      WindGustDir == "W" ~ "270",
      WindGustDir == "N" ~ "0",
      WindGustDir == "NE" ~ "45",
      WindGustDir == "E" ~ "90",
      WindGustDir == "S" ~ "180",
      TRUE ~ WindGustDir
    )
  )

obj5 = obj5 %>%
  mutate(
    WindGustDir2 = case_when(
      WindGustDir == "W" ~ "270",
      WindGustDir == "N" ~ "0",
      WindGustDir == "NE" ~ "45",
      WindGustDir == "E" ~ "90",
      WindGustDir == "S" ~ "180",
      TRUE ~ WindGustDir
    )
  )

# PR 1 -----
# Coba membuat kolom berdasarkan kolom yang sudah ada dengan kondisi operasi matemtika

glimpse(obj5)
glimpse(obj6)

# memilih baris (filter)
obj7 = weatherAUS %>%
  dplyr::filter(MinTemp >= 20)

# tanda & digunakan untuk mendapatkan range
obj8 = weatherAUS %>%
  dplyr::filter(MinTemp >= 15 & MinTemp <= 20)
summary(obj8)

# filter berdasarkan value string
obj9 = weatherAUS %>%
  dplyr::filter(Location == "Adelaide")

obj10 = weatherAUS %>%
  dplyr::filter(str_detect(Location, "Adel"))

summary(obj9)

# filter berdasar tanggal
library(lubridate)
obj11 = weatherAUS %>%
  dplyr::filter(lubridate::year(Date) == 2016 &
                  lubridate::month(Date) == 10)

# Data yg MinTemp == NA
obj12 = weatherAUS %>%
  dplyr::filter(is.na(MinTemp)) %>% # pilih baris yg valuenya == NA
  dplyr::group_by(Date) %>%
  dplyr::mutate(rerataMinTemp = mean(MinTemp))

# membuat rata2 MinTemp berdasarkan Date
# %>% dibaca pipe, jowo=njut, seterusnya
obj13 = weatherAUS %>%
  dplyr::filter(!is.na(MinTemp)) %>% # pilih baris yang value tidak sama dengan NA !=
  dplyr::group_by(Date) %>%
  dplyr::mutate(rerataMinTemp = round(mean(MinTemp), 1))

# membuat kolom baru berdasrakan kolom yang sudah ada
obj14 = weatherAUS %>%
  dplyr::mutate(KetHujan = case_when(RainTomorrow == "No" ~ "Terang",
                                     TRUE ~ "Hujan"))

# PR 2 -----
# tes melakukan pemilihan kolom, baris, dan kolom barus
NewData = weatherAUS %>%
  pilih_kolom %>% # select()
  pilih_baris %>% # filter()
  buat_kolom_baru # mutate()
