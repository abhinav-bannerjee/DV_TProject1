
COMB_FE_ <- df %>% select(COMB_FE_GUIDE)
COMB_FE_[COMB_FE_=="null"] <- NA
df$TRANS_DESC[df$TRANS_DESC =="null"] <-NA
df <- na.omit(df)
COMB_FE_ <- na.omit(COMB_FE_)
COMB_FE_$COMB_FE_GUIDE <- as.numeric(as.character(COMB_FE_$COMB_FE_GUIDE))
comb_fe <- colMeans(COMB_FE_)
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  facet_wrap(~DIVISION, ncol=6) +
  labs(title='Fuel Economy per Division  ') +
  labs(x=paste("DIVISION"), y=paste("COMB FE GUIDE")) +
  layer(data=COMB_FE_, 
          mapping=aes(yintercept = comb_fe-11), 
          geom="hline",
          geom_params=list(colour="red")
  ) +
  layer(data=df, 
        mapping=aes(x=TRANS_DESC, y=COMB_FE_GUIDE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="green"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(x=TRANS_DESC, y=(COMB_FE_GUIDE), label=(COMB_FE_GUIDE)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="red", hjust=-0.5), 
        position=position_identity()
  )
