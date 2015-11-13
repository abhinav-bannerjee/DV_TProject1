ggplot() + 
  scale_colour_gradient(name = "Comb Fe Guide", low="green",high = "green4")+
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Titanic') +
  labs(x="Annual Fuel Cost", y=paste("Comb Fe Guide")) +
  layer(data=df, 
        mapping=aes(x=as.numeric(as.character(ANNUAL_FUEL_COST)), y=as.numeric(as.character(COMB_FE_GUIDE)),color = as.numeric(as.character(COMB_FE_GUIDE)) ),
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )+geom_text(data = slice(df, c(1,24,50,70,90,100,150,200,250,300,350,400,450,480,500,550,600,650,700,750,800,850,900,950,1000,1050)), aes(x=as.numeric(as.character(ANNUAL_FUEL_COST)), y=as.numeric(as.character(COMB_FE_GUIDE)),label = DIVISION,hjust=0,vjust=0))

