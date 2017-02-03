dthrsoo16<-get(load("date-hour-soo-dest-2016.Rda"))
stname<-get(load("station_names.Rda"))

require(plyr)
require(dplyr)


dhse<-mutate(dthrsoo16, tripdate=as.Date(date, format="%Y-%m-%d"), tripday=weekdays(tripdate), tripmonth=months(tripdate), trippair=paste(start, end, sep="-"))

dhse_day<-group_by(dhse, tripday)
dhse_hr<-group_by(dhse, hour)
dhse_month<-group_by(dhse, tripmonth)
dhse_pair<-group_by(dhse, trippair)


daysum<-mutate(dhse_day, daycount=sum(count))
hrsum<-mutate(dhse_hr, hrcount=sum(count))
monthsum<-mutate(dhse_month, monthcount=sum(count))
pairsum<-mutate(dhse_pair, paircount=sum(count))

daysum1<-unique(daysum[,c("tripday", "daycount")])
hrsum1<-unique(hrsum[,c("hour", "hrcount")])
monthsum1<-unique(monthsum[,c("tripmonth", "monthcount")])
pairsum1<-unique(pairsum[,c("trippair", "paircount")])