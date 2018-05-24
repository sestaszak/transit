#circle graph
dthrsoo16<-get(load("date-hour-soo-dest-2016.Rda"))
stname<-get(load("station_info.Rda"))

require(plyr)
require(dplyr)


dhse<-mutate(dthrsoo16, tripdate=as.Date(date, format="%Y-%m-%d"), tripday=weekdays(tripdate), tripmonth=months(tripdate), trippair=paste(start, end, sep="-"))

rm(list="dthrsoo16")

test<-xtabs(count~start+end, data=dhse[which(dhse$start!="WSPR"), ])

test2<-as.data.frame(test)
#basic premade chord diagram
chordDiagram(test2[test2$Freq>10000,], transparency = 0.5)
