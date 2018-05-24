dthrsoo16<-get(load("date-hour-soo-dest-2016.Rda"))
stname<-get(load("station_info.Rda"))

require(plyr)
require(dplyr)


dhse<-mutate(dthrsoo16, tripdate=as.Date(date, format="%Y-%m-%d"), tripday=weekdays(tripdate), tripmonth=months(tripdate), trippair=paste(start, end, sep="-"))

rm(list="dthrsoo16")

test<-xtabs(count~start+end, data=dhse[which(dhse$start!="WSPR"), ])


dhse_day<-group_by(dhse, tripday)
dhse_hr<-group_by(dhse, hour)
dhse_month<-group_by(dhse, tripmonth)
dhse_pair<-group_by(dhse, trippair)
dhse_dayend<-group_by(dhse, tripday, end)
dhse_hrend<-group_by(dhse, hour, end)
dhse_hrsta<-group_by(dhse, hour, start)
dhse_daysta<-group_by(dhse, tripday, start)


daysum<-mutate(dhse_day, daycount=sum(count))
hrsum<-mutate(dhse_hr, hrcount=sum(count))
monthsum<-mutate(dhse_month, monthcount=sum(count))
pairsum<-mutate(dhse_pair, paircount=sum(count))
dayendsum<-mutate(dhse_dayend, dayendcount=sum(count))
hrendsum<-mutate(dhse_hrend, hrendcount=sum(count))
hrstasum<-mutate(dhse_hrsta, hrstacount=sum(count))
daystasum<-mutate(dhse_daysta, daystacount=sum(count))

daysum1<-unique(daysum[,c("tripday", "daycount")])
hrsum1<-unique(hrsum[,c("hour", "hrcount")])
monthsum1<-unique(monthsum[,c("tripmonth", "monthcount")])
pairsum1<-unique(pairsum[,c("trippair", "paircount")])
dayendsum1<-unique(dayendsum[,c("tripday", "end", "dayendcount")])
hrendsum1<-unique(hrendsum[,c("hour", "end", "hrendcount")])

dhsecounts<-data.frame(dhse, daycount=daysum$daycount, hrcount=hrsum$hrcount, monthcount=monthsum$monthcount, 
                       paircount=pairsum$paircount, dayendcount=dayendsum$dayendcount, hrendcount=hrendsum$hrendcount, 
                       hrstacount=hrstasum$hrstacount, daystacount=daystasum$daystacount)

rm(list=c("dhse_day", "dhse_hr", "dhse_month", "dhse_pair", "dhse_dayend", "dhse_hrend", "dhse_hrsta", "dhse_daysta", 
          "daysum", "hrsum", "monthsum", "pairsum", "dayendsum", "hrendsum","hrstasum", "daystasum", "dhse"))
# rm(list=c("daysum1", "hrsum1", "monthsum1", "pairsum1", "dayendsum1", "hrendsum1"))

# dhse<-merge(x=dhsecounts, y=stname, by.x="start", by.y="stcode4", suffixes=c("", ".strt"))
# dhsecse<-merge(x=dhsec_st, y=stname, by.x="end", by.y="stcode4", suffixes=c("", ".end"))




#plot station on x time on y with counts for time + end station pair counts
#want size of bubble to be area not radius... so math
#radius <- sqrt( var / pi )
#symbols(xvar, yvar, circles=radius)
hrendst<-merge(x=hrendsum1, y=stname, by.x = "end", by.y = "stcode4")
oddstation<-levels(hrendst$end)[seq(from=1, to=45, by=2)]
evenstation<-levels(hrendst$end)[seq(from=2, to=44, by=2)]

hrendst$oddeven<-ifelse(hrendst$end%in%oddstation, 0, ifelse(hrendst$end%in%evenstation, 1, NA))


#### plots

op<-par(mai=c(.5, 1, .5, 1))
rhrend<-sqrt(hrendst$hrendcount/20)
#add some space for plotting yaxis labels
symbols(y=hrendst$end, x=hrendst$hour, circles=rhrend, inches = .2, yaxt="n", xlim=c(5,11), bg=hrendst$stcounty, fg="white", xlab="Hour (A.M.)", ylab="") 
#add horizontal light grey lines
abline(h=unique(hrendst$end), col="gray")
#fix this axis so that names alternate sides, currently by obs not by level
axis(2, at =hrendst[which(hrendst$oddeven==0), "end"] ,labels=hrendst[which(hrendst$oddeven==0), "end"], las=2, cex=.4)
axis(4, at =hrendst[which(hrendst$oddeven==1), "end"] ,labels=hrendst[which(hrendst$oddeven==1), "end"], las=2, cex=.4)
#add xaxis labels back in, maybe only for a subset of stations

symbols()


