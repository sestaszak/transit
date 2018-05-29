#circle graph
dthrsoo16<-get(load("date-hour-soo-dest-2016.Rda"))
stname<-get(load("Station_information.Rda"))

require(plyr)
require(dplyr)
require(circlize)

dhse<-mutate(dthrsoo16, tripdate=as.Date(date, format="%Y-%m-%d"), tripday=weekdays(tripdate), tripmonth=months(tripdate), trippair=paste(start, end, sep="-"))

rm(list="dthrsoo16")

m1<-merge(x=dhse, y=stname[,c("stcode4", "cityname")], by.x="start", by.y="stcode4", 
          suffixes=c("", ".start"), all.x=TRUE)
m2<-merge(x=m1, y=stname[,c("stcode4", "cityname")], by.x = "end", by.y = "stcode4", 
          suffixes=c("", ".end"), all.x = TRUE)

test<-xtabs(count~cityname+cityname.end, data=m2[which(m2$start!="WSPR"), ])

test2<-as.data.frame(test)
#basic premade chord diagram
chordDiagram(test2[test2$Freq>10000,], transparency = 0.5)
# chordDiagram(test2, transparency=0.5)


#change labels on diagram
##example to do that from https://jokergoo.github.io/circlize_book/book/advanced-usage-of-chorddiagram.html#customize-sector-labels

# chordDiagram(mat, grid.col = grid.col, annotationTrack = "grid", 
#              preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(mat))))))
# # we go back to the first track and customize sector labels
# circos.track(track.index = 1, panel.fun = function(x, y) {
#   circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
#               facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
# }, bg.border = NA) # here set bg.border to NA is important
