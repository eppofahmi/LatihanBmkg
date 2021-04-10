library(tidyverse)
library(janitor)
library(readxl)
library(zoo)
library(xlsx)
library(lubridate)

#' Calculate EDI
#'
#' @param data data frame (dua kolom pertama namanya harus tahun dan hari)
#' @param station string nama stasiun
#' @param mean_mep numerik jumlah moving average 
#'
#' @return data frame with 
#' @export
#'
#' @examples
cal_edi = function(data, station, mean_mep){
  kolom = station
  df1 = data
  
  df2 = df1 %>% 
    select(tahun, hari, sym(kolom)) 
  
  # calculate ep
  x = as.vector(df2[, 3])
  x = as.vector(x)
  
  ep <- rollapplyr(x, 2, function(x) sum(cumsum(x) / seq_along(x)), fill = NA)
  
  # calculate mean of ep per 5 days
  mean_mep = rollmean(ep, mean_mep)
  
  # make sure length of mean mep same with ep
  t1 = length(ep) - length(mean_mep)
  t2 = c(paste0(0,seq_along(1:t1)))
  for (i in seq_along(1:length(t2))) {
    print(t2[i])
    t2[i] = 0
  }
  t2=as.numeric(t2)
  
  # append data
  mean_mep = append(mean_mep, t2)
  
  dep = ep - mean_mep
  sd_dep = stats::sd(dep, na.rm = TRUE)
  
  df3 = tibble(ep = ep, dep = dep)
  df3$edi = df3$dep/sd_dep
  df3 = df3 %>% 
    mutate(ep = as.double(ep), 
           dep = as.double(dep), 
           edi = as.double(edi))
  
  df2 = bind_cols(df2, df3)
  return(df2)
}

# load data --------------------------------------------------------
df1 <- read_excel("data/mentah/Data Hujan Harian 2010-2019.xlsx") # data yang akan dihitung
df1 = janitor::clean_names(df1) # memastikan nama kolom jadi symbol, tanpa spasi atau angka di depan
kolom = colnames(df1) # cek nama kolom yang ada
kolom = kolom[3:24]

for (i in seq_along(1:length(kolom))) {
  print(kolom[i])
  # example
  stasiun = kolom[i] # nama stasiun yang juga akan digunakan untuk nama file yang disimpan
  tes = cal_edi(data = df1, station = stasiun, mean_mep = 5)
  
  tes$tanggal = seq(as.Date("2010/01/01"), by = "day", length.out = nrow(tes))
  
  tes = tes %>% 
    mutate(yearmonth = paste0(year(tanggal), "-", month(tanggal))) %>% 
    group_by(yearmonth) %>% 
    mutate(mean_edi = mean(edi, na.rm = TRUE))
  # untuk melihat hasil hilangkan tanda pagar di kiri View
  # View(tes) 
  
  # save to excel
  folder = paste0(getwd(), "/data/bersih/edi/") # ganti /data/bersih/ dengan nama folder yang sesuai
  namafile = paste0("edi-", stasiun, ".xlsx")
  writexl::write_xlsx(tes, paste0(folder, namafile))
  
  # file saya disimpan di mana?
  print(paste0(
    "File ", namafile, " tersimpan di ", folder
  ))  
}
