# Troubleshooting
# 
# 1. Jika tidak bisa install package 
# - install rtools dengan cara mengunduhnya langsung dari laman: https://cran.r-project.org/bin/windows/Rtools/
#   - coba ikuti petunjung penginstallan rtools dari laman: https://cran.r-project.org/bin/windows/Rtools/
#   
#   2. Tidak bisa intall package dengan basis java - misalnya xlsx
# - Install java lebih dulu sesuai dengan mesin yang digunakan 32 atau 64 bit. 
# - Java bisa diunduh di: https://www.oracle.com/java/technologies/javase-downloads.html atau googling untuk mendapatkan yang sesuai
# - install.packages("rJava")
# - letakan skrip berikut di bari paling atas sblm memanggil library xlxs
# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk-10.0.1/")

# Day-1 --------------------------------------------------
# 1. Rstudio Cloud 
# 2. Membuat project
# 3. Membuat dan menyimpan script

# 4. Operator penugasan #, <-/=, ?, %>% (njut/then)
# semua yg didahului tanda # tidak akan dibaca sebagai perintah
## tanda pagar berfungsi sbg komentar
1 + 1
# 1 + 1

## tanda "<-" sama dengan tanda "=" 
data1 <- 50 * 3
data2 <- 100 * 5
data3 <- data1 + data2

data1 = 50 * 3
data2 = 100 * 5
data3 = data1 + data2

data4 = data3 * 2
data4 = Data3 * 2

# untuk menghapus object dari working space/environment
rm(data3)

## nama objek tidak boleh menggunakan spasi atau diawali dengan angka
data 5 = 16 / 4 # error karena ada spasi "data 5"
data_5 = 16 / 4
5data = 16 / 4 # error karena 5 di depan
data5 = 16 / 4

## tanda tanda (?)
?shiny
??shiny
?read.csv

# 5. Package dan Library
## memanggil library/package 
## install dengan sintaks hanya dilakukan 1 kali
install.packages("namapackage")

# Untuk install dari github
install.packages("devtools") # untuk menginstall package dari sumber github/gitlab
devtools::install_github("eppofahmi/dataplot") # contoh 1 dari github
devtools::install_github("juliasilge/tidytext") # contoh 2 dari github

install.packages("tidyverse")
install.packages("readxl") # untuk membaca file excel
install.packages("xlsx") # untuk membaca dan menulis/menyimpan file excel

install.packages("echarts4r") # visualisasi data
install.packages("tidync") # load data 
install.packages("ncdf4") # load data 

# memanggil setiap ada sesi baru R/Rstudio
library(tidyverse)
library(dataplot)
library(readxl)

# menggunakan fungsi scr spesifik dari sebuah pckg contoh
dplyr::filter() # menggunakan fungsi filter dari pckg dplyr

# 6. Fungsi
# filter()
# filter = nama fungsi
# () = isinya adalah argumen

## 6a. Fungsi paste
## 6b. Fungsi if dan else
### if butuh kondisi 
### jika kondisinya tidak terpenuhi makan else

## 6c. Fungsi loop
### iterasi/perulangan
### membaca data 
### untuk memastikan sebuah fungsi diambil dari package tertentu