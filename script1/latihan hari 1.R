# Day-1 --------------------------------------------------
# 1. Rstudio Cloud
# 2. Membuat project
# 3. Membuat dan menyimpan script
# 4. Operator penugasan #, <-/=, ?, %>%
     # tanda pagar berfungsi sbg komentar
78 + 19
# 78 + 19

     # tanda "<-" sama dengan tanda "=" 
data1 <- 78 + 19
data1 = 78 + 19

    # nama objek tidak boleh menggunakan spasi atau diawali dengan angka
data 2 = 78 / 19
    # seharusnya
data_2 = 78 / 19

3 data = 54 / 3
3data = 54 / 3
data3 = 54 / 3

    # tanda tanda (?)
?rmarkdown
??rmarkdown
  
# 5. Package dan Library
# memanggil library/package 
library(rmarkdown)
library(shiny)

# install dengan sintaks
install.packages("rknn") 
library(rknn)
?rknn

# 6. Fungsi 
## 6a. Fungsi paste
teks1 = "aku mau makan"
teks2 = "nasi padang karena sudah lapar"

teks3 = paste(teks1, teks2)
teks3 = paste0(teks1, " ", teks2)

## 6b. Fungsi if dan else
# if butuh kondisi 
# jika kondisinya tidak terpenuhi makan else
TimA = 8
TimB = 9

if (TimA > TimB){
  # tindakan
  print("Tim B Kalah")
  hasil = TimA - TimB
} else if(TimA == TimB){
  # tindakan
  print("Tim A dan B Seri")
  hasil = TimA - TimB
} else {
  # tindakan
  print("Tim B Menang")
  hasil = TimA - TimB
}

## 6c. Fungsi loop
# iterasi/perulangan
library(tidyverse)
tes_data = economics

for (i in seq_along(1:nrow(tes_data))) {
  print(tes_data$psavert[i])
  if(tes_data$psavert[i] %% 2 == 0){
    print("genap")
    tes_data$keterangan[i] = "genap"
  } else {
    print("ganjil")
    tes_data$keterangan[i] = "ganjil"
  }
}

# membaca data 
# untuk memastikan sebuah fungsi diambil dari package tertentu
readr::read_csv()
??read_csv