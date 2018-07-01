if(!(require("readr"))){install.packages("readr")}
if(!(require("dplyr"))){install.packages("dplyr")}


jun <- as.data.frame(readr::read_csv("data/2015_06_T_ONTIME.csv"))
jul <- as.data.frame(readr::read_csv("data/2015_07_T_ONTIME.csv"))
aug <- as.data.frame(readr::read_csv("data/2015_08_T_ONTIME.csv"))
sep <- as.data.frame(readr::read_csv("data/2015_09_T_ONTIME.csv"))

mydatalist <- list(jun, jul, aug, sep)

airlinecodes <- readr::read_csv("data/L_CARRIER_HISTORY.csv")
usaircode <- airlinecodes[airlinecodes$Code == "US",]
airlinecodes <- airlinecodes[(!grepl("-\\s\\d\\d\\d\\d", airlinecodes$Description)),]
airlinecodes <- rbind(airlinecodes, usaircode[2,])

airlinecodes$Airline <- gsub("\\s\\(\\d\\d\\d\\d.*?\\)", "", airlinecodes$Description)

airlinecodes <- airlinecodes[,c("Code", "Airline")]

addcolon <- function(mytime){
  mytime <- gsub("(\\d\\d$)", "\\:\\1", mytime)
  return(mytime)
}


for(i in 1:4){
  mydatalist[[i]]$CRS_DEP_TIME <- addcolon(mydatalist[[i]]$CRS_DEP_TIME)
  mydatalist[[i]]$DEP_TIME <- addcolon(mydatalist[[i]]$DEP_TIME)
  mydatalist[[i]]$CRS_ARR_TIME <- addcolon(mydatalist[[i]]$CRS_ARR_TIME)
  mydatalist[[i]]$ARR_TIME <- addcolon(mydatalist[[i]]$ARR_TIME)
}



summer15 <- do.call(rbind, mydatalist)

summer15 <- merge(summer15, airlinecodes, by.x = "CARRIER", by.y = "Code", all.x = TRUE)

summer15 <- summer15[,c("MONTH", "FL_DATE", "Airline", "FL_NUM", "ORIGIN", "ORIGIN_CITY_NAME", "ORIGIN_STATE_ABR", "DEST", "DEST_CITY_NAME", "CRS_DEP_TIME", "DEP_DELAY", "ARR_DELAY", "CANCELLED", "CARRIER_DELAY", "WEATHER_DELAY", "NAS_DELAY", "SECURITY_DELAY", "LATE_AIRCRAFT_DELAY")]

write.csv(summer15, "files2zip/summer15delays.csv", row.names = FALSE, na="")

write.csv(airlinecodes, file="data/airlines.csv", row.names = FALSE)


write.csv(mydatalist[[1]], "data/2015_06_T_ONTIME.csv", row.names = FALSE, na="")
write.csv(mydatalist[[2]], "data/2015_07_T_ONTIME.csv", row.names = FALSE, na="")
write.csv(mydatalist[[3]], "data/2015_08_T_ONTIME.csv", row.names = FALSE, na="")
write.csv(mydatalist[[4]], "data/2015_09_T_ONTIME.csv", row.names = FALSE, na="")
