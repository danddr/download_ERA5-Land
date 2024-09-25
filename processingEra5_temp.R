setwd("/home/daniele/Downloads/")
library(terra)
library(sf)
library(dplyr)
library(lubridate)
library(geodata)

#load temperatures ncdf files
b<-list.files( recursive=TRUE, full.names = T, pattern = "tas_era5Land")
mymask <-  geodata::gadm(country=c("BEL"), level=0, path = "/home/daniele/Downloads/")

dailyT_list<-list()
for(i in 1:length(b)){
  # i=1
  tmp<-terra::rast(b[i])
  message("Processing month ", i, " of ", length(b), ": ", unique(lubridate::month(terra::time(tmp))), "/", unique(lubridate::year(terra::time(tmp))))
  cheatTab <-data.frame(date=as.Date(terra::time(tmp)))
  cheatTab <- transform(cheatTab, id=as.numeric(factor(date)))
  tmp <- terra::tapp(tmp, index=cheatTab$id, fun = mean, cores=4) # get daily mean
  tmp <- terra::mask(tmp, mymask)
  tmp <- terra::app(tmp, fun = function(x){x-273.15}, cores=4)
  names(tmp) <- unique(cheatTab$date)
  terra::time(tmp)<-unique(cheatTab$date)
  dailyT_list[i]<-tmp
  rm(tmp, cheatTab)
}
dailyT_list<-do.call(c, dailyT_list)

outname<-paste0("be_dailyT_2018_2022", ".RDS" )
myout<-saveRDS(dailyT_list, outname)

