# 10_MT_KPI_SL_INV#R
setwd("C:/Users/LENOVO/Desktop/SubscribeMyChannel")
library(dplyr)
library(purrr)
library(tidyr)
library(tibble)
library(ggplot2)
library(gridExtra)


#### Part 1

db_1<-tibble(
   pop_1=rnorm(15000,mean=45.65,sd=1),
   pop_2=rnorm(15000,mean=45.65,sd=29.23),
   ord=1:15000
)


ggplot(data=db_1,aes(x=pop_1))+
   geom_histogram(aes(color=abs(pop_1-45.65)>=2),bins=50)+
   labs(x="Distribution for Population with sd=1")+
   theme(legend.position = "none") 


quantile(db_1$pop_1,probs=c(0.05,0.5,0.95))


quantile(db_1$pop_2,probs=c(0.05,0.5,0.95))


y_labels<-round(quantile(db_1$pop_2,
                         probs=c(0.05,0.20,0.5,0.8,0.95)),1)

quantile(db_1$pop_2,probs=c(0.05,0.5,0.95)) %>% 
   boxplot(col="red",yaxt="n")
axis(side = 2, at = y_labels )
text(x=1.2, y= round(quantile(db_1$pop_2,probs=0.95),2 ), 
     labels="95% Quantile" )
text(x=1.2, y= round(quantile(db_1$pop_2,probs=0.05),2 ), 
     labels="5% Quantile" )

############# PART 2

contr_mat<-tibble(Parameters=c("Mean","Stan_Dev"),
                  We_Want_Pop_1=c(45.65,1),
                  We_Get_Pop_1=c( mean(db_1$pop_1),sd(db_1$pop_1)  ),
                  
                  We_Want_Pop_2=c(45.65,29.23),
                  We_Get_Pop_2=c( mean(db_1$pop_2),sd(db_1$pop_2)  )
                  
)   
contr_mat

sam_2<-sample(db_1$pop_2,750,replace = FALSE) %>% 
   tibble %>% rename(sam_750=".") 


ggplot(data=db_1,aes(x=(pop_2-mean(pop_2) )/29.23,
                     y=as.numeric(reorder(pop_2,ord))  )  )+
   geom_point(col="red") + 
   labs(y="Random Variables",x="Z Score")+
   theme(axis.text.y=element_blank() , legend.position = "none")



ggplot(data=db_1,aes(x=(pop_2-mean(pop_2) )/29.23,
                     y=as.numeric(reorder(pop_2,ord))  )  )+
   geom_point(aes(col=pop_2 %in% sam_2$sam_750)) + 
   labs(y="Random Variables",x="Z Score")+
   theme(axis.text.y=element_blank() , legend.position = "none")



contr_mat<-tibble(We_Want=c(45.65,29.23),
                  We_Get=c( mean(sam_2$sam_750),sd(sam_2$sam_750)  ))   
contr_mat



sam_2<-sample(db_1$pop_2,1500,replace = FALSE) %>% 
   tibble %>% rename(sam_1k=".") 

ggplot(data=db_1,aes(x=(pop_2-mean(pop_2) )/29.23,
                     y=as.numeric(reorder(pop_2,ord))  )  )+
   geom_point(aes(col=pop_2 %in% sam_2$sam_1k)) + labs(y="Random Variables",x="Z Score")+
   theme(axis.text.y=element_blank() ,
         legend.position = "none")

contr_mat<-tibble(We_Want=c(45.65,29.23),
                  We_Get=c( mean(sam_2$sam_1k),sd(sam_2$sam_1k)  ))   
contr_mat

############# PART 3

n<-20  # i will take 15 samples 
sample_mean_collection<-vector(mode="numeric",length=n) # here we store sample means
sample_sd_collection<-vector(mode="numeric",length=n)# here we store sample sd

sample_sizes<-seq(100,5000,length.out = 20) # here we have sample sizes
# largest sample will have 5000 poins
j<-1
for (i in sample_sizes  ) {
   sample_mean_collection[j]<-sample(db_1$pop_2,i) %>% mean
   sample_sd_collection[j]<-sample(db_1$pop_2,i) %>% sd
   j<-j+1
}


db_2<-tibble(sam_mean=sample_mean_collection,
             sam_sd= sample_sd_collection,
             s_size=sample_sizes)


pl_1<-ggplot(data=db_2,aes(x=s_size,y=sam_mean))+
   geom_line(col="blue",cex=1)+
   geom_point(col="red",cex=3)+
   geom_hline(yintercept=45.65,col="green",cex=1)


pl_2<-ggplot(data=db_2,aes(x=s_size,y=sam_sd))+
   geom_line(col="blue",cex=1)+
   geom_point(col="red",cex=3)+
   geom_hline(yintercept=29.23,col="green",cex=1)

gridExtra::grid.arrange(pl_1,pl_2,nrow=2)


#Part 4

n<-20
replicate( n, sample(db_1$pop_2,10,replace=TRUE)  ) 

rep_1<-replicate( n, mean( sample(db_1$pop_2,10,
                                  replace=TRUE)))

dev.off()
hist(rep_1,breaks=15,col="red")



contr_mat<-tibble(We_Want=c(45.65,29.23),
                  We_Get=c( mean(rep_1),sd(rep_1)  ))   
contr_mat


rep_1<-replicate( 10, mean( sample(db_1$pop_2,10,replace=TRUE)  )   )
hist(rep_1,breaks=15,main=paste(29.23," VS ",round(sd(rep_1),2)  ) )
abline(v = 45.65, col="red", lwd=3, lty=2)
abline(v = mean(rep_1), col="blue", lwd=3, lty=2)



rep_2<-replicate( 20, mean( sample(db_1$pop_2,10,replace=TRUE)  )   )
hist(rep_2,breaks=15,main=paste(29.23," VS ",round(sd(rep_2),2)  ) )
abline(v = 45.65, col="red", lwd=3, lty=2)
abline(v = mean(rep_2), col="blue", lwd=3, lty=2)

rep_3<-replicate( 100, mean( sample(db_1$pop_2,10,replace=TRUE)  )   )
hist(rep_3,breaks=15,main=paste(29.23," VS ",round(sd(rep_3),2)  ) )
abline(v = 45.65, col="red", lwd=3, lty=2)
abline(v = mean(rep_3), col="blue", lwd=3, lty=2)

rep_4<-replicate( 500, mean( sample(db_1$pop_2,10,replace=TRUE)  )   )
hist(rep_4,breaks=15,main=paste(29.23," VS ",round(sd(rep_4),2)  ) )
abline(v = 45.65, col="red", lwd=3, lty=2)
abline(v = mean(rep_4), col="blue", lwd=3, lty=2)

#Part 5

n<-70  # i will take 70 samples to estimate sd of means
sample_sd_collection<-vector(mode="numeric",length=n)

sample_sizes<-seq(100,8000,length.out = 70) # here we have sample sizes

#  Sample size determins number of means, not individual observations.
#  For each sample we will  caclulate sample mean and  will use only 10 observatios.

for (i in 1:n  ) {
   sample_sd_collection[i]<-replicate(sample_sizes[i], mean( sample(db_1$pop_2,10  ) ) ) %>% sd
}


db_3<-tibble(sam_sd= sample_sd_collection,
             s_size=sample_sizes)


ggplot(data=db_3,aes(x=sample_sizes,y=sam_sd))+
   geom_line(col="blue",cex=1)+
   geom_point(col="red",cex=3)+
   geom_hline(yintercept=29.23/sqrt(10),col="green",cex=1)




