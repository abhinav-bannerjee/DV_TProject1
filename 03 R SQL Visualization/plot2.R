KPI_Low = 20;    
KPI_Medium = 31;
a <- df  %>% select(TRANS_DESC,DRIVE_DESC,CARLINE,COMB_FE_GUIDE,FE_RATING_1_10)%>% group_by(TRANS_DESC,DRIVE_DESC) %>% summarise(comb_fe = round(mean(as.numeric(as.character(COMB_FE_GUIDE))),2),fe_rating = round(mean(as.numeric(as.character(FE_RATING_1_10))),digits=1))
a<-na.omit(a)
a <- a%>% mutate(KPI_COMB_FUEL = ifelse(as.numeric(as.character(comb_fe)) < KPI_Low, 'Less than 20', ifelse(as.numeric(as.character(comb_fe)) < KPI_Medium, 'Between 20 and 30', 'Greater than 30')))


ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  scale_x_discrete(labels=c("Automated Manual","Automated Manual- Selectable","Automatic","Continuously Variable","Manual","Selectable Continuously Variable","Semi-Automatic") )+
  labs(title='CROSSTAB') +
  labs(x=paste("Transmission"), y=paste("Drive")) +
  layer(data=a, 
        mapping=aes(x=TRANS_DESC, y=DRIVE_DESC,fill=KPI_COMB_FUEL), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )+ 
  layer(data=a, 
            mapping=aes(x=TRANS_DESC, y=DRIVE_DESC, label= fe_rating), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", vjust =2), 
            position=position_identity()
  )+ 
  layer(data=a, 
        mapping=aes(x=TRANS_DESC, y=DRIVE_DESC, label= comb_fe), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust =4), 
        position=position_identity()
  )
