tes$tanggal = seq(as.Date("2010/01/01"), by = "day", length.out = nrow(tes))

tes = tes %>% 
  mutate(yearmonth = paste0(year(tanggal), "-", month(tanggal))) %>% 
  group_by(yearmonth) %>% 
  mutate(mean_edi = mean(edi, na.rm = TRUE))