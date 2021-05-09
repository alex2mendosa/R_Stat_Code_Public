setwd("C:\\Users\\LENOVO\\Desktop\\SubscribeMyChannel")
library(dplyr)  # data wrangling
library(tidyr)  # data wrangling
library(tibble) # data wrangling
library(ggplot2) # visuals
library(class)  # model building


#######################  PART_1

# data frame with random features
set.seed(123)
sample_1<-data.frame(  feature_BMI=c( runif(1,18.5,24.9),
                                      runif(1, 25.0,29.9)),
                       class=c( "Healthy weight","Overweight" ),
                       row.names=c("inst_1  ","inst_2  ")   )

View(sample_1)

# visualise with ggplot2
ggplot2::ggplot(data=sample_1,aes(y= feature_BMI ,x=class))+
  geom_point(col="red",cex=10)+
  geom_label(aes(label=round(feature_BMI,2)  ),nudge_y = 0.5 )+
  theme(axis.text=element_text(size=15) )


# create record we need to classify

new_point<-runif(1,18.5,29.9) %>% round(2) # generate random point

ggplot2::ggplot(data=sample_1,aes(y= feature_BMI ,x=class))+
  geom_point(aes(col=class),cex=10)+
  geom_label(aes(label=round(feature_BMI,2)  ),nudge_y = 0.1,nudge_x=0.2 )+
  geom_point(col="red")+geom_point(aes(y=new_point),col="blue",cex=11) +
  geom_segment(x="Healthy weight",y=new_point,xend = "Healthy weight", yend = sample_1$feature_BMI[1],
               color="green")+
  geom_segment(x="Overweight",y=new_point,xend = "Overweight", yend = sample_1$feature_BMI[2],
               color="green")+
  geom_label(aes(label=round(new_point,2),x=class,y=new_point  ),nudge_y = 0.1,nudge_x=0.2 )+
  theme(axis.text=element_text(size=15) )


# Euclidian Distance between 2 poins
dist_1<- sqrt( (new_point-sample_1$feature_BMI[1])^2 )
dist_2<- sqrt( (new_point-sample_1$feature_BMI[2])^2 )

# absolute value of difference
abs( new_point-sample_1$feature_BMI[1] )
abs( new_point-sample_1$feature_BMI[2] )


#add new column to sample_1
sample_1<-sample_1 %>% 
       dplyr::mutate(Eu_Dist=sqrt( (new_point-feature_BMI)^2 ))

# add new record with class we dont know
sample_1<-sample_1 %>%
  dplyr::bind_rows( tibble(feature_BMI=new_point,class=NA,Eu_Dist=0) )
row.names(sample_1)[3]<-3

sample_1$class[3]<-sample_1$class[ which.min(sample_1$Eu_Dist[1:2]) ] 
# use which.min to identify index of smallest value


# call for knn function from class package
class::knn( train=sample_1[c(1,2),1], # we define only features of training set
            test=new_point, # define value we need to classify
            cl=sample_1[c(1,2),2], # classes of training set
            k=1 ) # how many neighbours to consider

# lets proceed to ggplot 2
ggplot(data=sample_1,aes(y= feature_BMI ,x=class))+
  geom_point(col="red",cex=8)+
  geom_label(aes(label=round(feature_BMI,2)  ),nudge_y = 0.1,nudge_x=0.2 )+
  geom_point(col="red")+geom_point(aes(y=new_point),col="blue",cex=9) +
  geom_segment(x="Healthy weight",y=new_point,xend = "Healthy weight", yend = sample_1$feature_BMI[1],
               color="green")+
  geom_segment(x="Overweight",y=new_point,xend = "Overweight", yend = sample_1$feature_BMI[2],
               color="green")+
  geom_label(aes(label=round(new_point,2),x=class,y=new_point  ),nudge_y = 0.1,nudge_x=0.2 )+
  geom_label(aes(label=paste( "sqrt","(","(",round(new_point,2),"-",
                              round(feature_BMI[1],2) ,")","^2",")"),
                 x="Healthy weight",y=new_point  ),nudge_y = 2,nudge_x=0,size=5 )+
  geom_label(aes(label=paste( "sqrt","(","(",round(new_point,2),"-",
                              round(feature_BMI[2],2) ,")","^2",")"),
                 x="Overweight",y=new_point  ),nudge_y = 2,nudge_x=0,size=5 )


#######################  PART_2

# 1 feature,  multiple records

set.seed(123)
sample_3<-data.frame(  feature_BMI=c( runif(3,18.5,24.9),
                                      runif(3, 25.0,29.9)),
                       class=c( rep("Healthy weight",3),rep("Overweight",3) ) )
View(sample_3)

new_point<-24.5

# Visualisation
ggplot(data=sample_3,aes(y= feature_BMI ,x=class))+
  geom_point(col="red",cex=6)+
  geom_label(aes(label=round(feature_BMI,2)  ),nudge_y = 0.1,nudge_x=0.2 )+
  geom_point(col="red")+geom_point(aes(y=new_point),col="blue",cex=5) +
  geom_label(aes(label=round(new_point,2),x=class,y=new_point  ),nudge_y = 0.1,nudge_x=0.2,color="blue" )+
  theme(axis.text=element_text(size=15) )

#mutate function 
sample_3<-sample_3 %>% 
        dplyr::mutate(Eu_Dist=sqrt( (new_point-feature_BMI)^2 ))

# plot the equations for single class
ggplot2::ggplot(data=sample_3,aes(y= feature_BMI ,x=class))+
  geom_point(col="red",cex=6)+
  geom_label(aes(label=round(feature_BMI,2)  ),nudge_y = 0.5,nudge_x=0.2 )+
  geom_point(col="red")+geom_point(aes(y=new_point),col="blue",cex=5) +
  geom_label(aes(label=round(new_point,2),x=class,y=new_point  ),nudge_y = 0.1,nudge_x=0.2,color="blue" )+
  geom_label(aes(label=paste("sqrt","(","(",round(new_point,2),"-",round(feature_BMI[1],2) ,")","^2",")","\n",
                             "sqrt","(","(",round(new_point,2),"-",round(feature_BMI[2],2) ,")","^2",")","\n",
                             "sqrt","(","(",round(new_point,2),"-",round(feature_BMI[3],2) ,")","^2",")"),
                 x="Healthy weight",y=new_point  ),nudge_y = 4,nudge_x=0,size=5 )+
  theme(axis.text=element_text(size=15) )


# Assume  k equals 3 , therefore, we need to choose
# 3 nearest neighbours or 3 lowest  values for distance

sample_3 <-sample_3 %>% dplyr::arrange(Eu_Dist) %>% dplyr::slice(1:3)

table(sample_3$class) # use table() to count unique classes
prop.table( table(sample_3$class) ) # prop.table is used 
# to check share of class
# this is our voting result, we should
# select the most probable [popular] class

# here is the solution for knn function
class::knn( train=sample_3[,1],
            test=new_point,
            cl=sample_3[,2],
            k=3, 
            prob=TRUE )


############ PART 3


sample_4<-iris
View(sample_4)

# check how exactly features are dissimilar in 
# terms  of central tendency and spread
summary(sample_4[,-5])

# use glimpse to inspect data frame
tibble::glimpse(sample_4)


# sample single row we would like to predict
set.seed(321)
loc<-sample(1:nrow(sample_4),1 ) # randomly generate index
test_row_1<-sample_4[ loc[1]   , -5  ] # here we store 1 record we need to classify
test_row_cl<-sample_4[ loc[1]   , 5  ] # here we store actual classes for test record

# what classes are available 
sample_4$Species %>% unique()
# we have 3 unique classes

# we would require to group data and take 1 sample from each group
train_row_3<-sample_4[-loc,] %>% dplyr::group_by(Species) %>%
  slice(1)
# We extract first record from each group, therefore
# we have 1 instance for each class training set


# convert train_row_3 and test_row_1 to long format
gg_train<-train_row_3 %>% tidyr::pivot_longer(Sepal.Length:Petal.Width ,
                                              names_to="Feature") %>%
  rename("Class"="Species")  

gg_test<-test_row_1 %>% tidyr::pivot_longer(Sepal.Length:Petal.Width ,
                                            names_to="Feature") %>%
  mutate(Class="Unknown") %>% dplyr::select(Class,Feature,value)

gg_in<-dplyr::bind_rows(gg_train,gg_test)

ggplot2::ggplot(data=gg_in,aes(y=Class,x=value))+ 
  geom_point(aes(col= Class),cex=5)+
  geom_text(aes(label=round(value,2),color=Class ),cex=4,nudge_y = 0.2 ) + 
  facet_grid(~Feature,  space="free") +
  theme_bw(base_size = 15)


cat( "sqrt(  (4.8-6)^2+(1.4-2.5)^2+(6.8-6.3)^2+(2.8-3.3)^2    )"    )

#  substract train set form test set 
train_row_3[,-5]-test_row_1 # different number of rows , we need to triple
                            # first  record in test set
train_row_3[,-5]-test_row_1[ c(1,1,1),]   # vector is used to repeat
                                          # single row 3 times

# Whole Equation
Euc_Dist=rowSums( (train_row_3[,-5]-test_row_1[ c(1,1,1), ])^2 ) %>% sqrt()

train_row_3 %>% ungroup() %>% mutate(Euc_Dist=Euc_Dist) %>%
  arrange(Euc_Dist) %>% slice(1)
test_row_cl

class::knn( train=train_row_3[,-5],
            test=test_row_1,
            cl=dplyr::pull(train_row_3[,5]), # here I use pull() 
                                      # because cl accepts vector as input
            k=1)                             

test_row_cl # actual class of test row


############ PART 4
#   iris dataset , with  80,20 split,

set.seed(253)
loc<-sample(1:nrow(iris),nrow(iris)*0.2 ) # test records indices
test_set<-iris[ loc   , -5 ] # generate test set
test_set_cl<-iris[ loc   , 5 ] # store actual classes of test set
train_set<-iris[ -loc   , ] # use  minus
#to select rows which are not part of test set

# How would knn fucntion perform
m1_knn<-knn( train=train_set[,-5],
             test=test_set,
             cl=train_set[,5], k=3)

# now we calculate accuracy, how many values in 
# m1_knn  equal to values in test set classes
sum(m1_knn==test_set_cl)/ length(test_set_cl)


############### 
n_test<-nrow(test_set) # number of rows in test set
n_train<-nrow(train_set) # number of rows in training  set
out<-rep("",n_test) # out vector would store  result of classification 
                    # of test values

i<-1
for ( i in 1:n_test) { # we go through each record of test set
    # estimate Eu_Distance between single row of test set and all rows of train set
  Eu_Dist=rowSums( (train_set[,-5] - test_set[i,][c(rep(1,n_train)), ] ) ^2 ) %>% sqrt()
  train_buf<-train_set %>% mutate(Eu_Dist=Eu_Dist) %>% arrange(Eu_Dist) %>%
    slice(1:3) # select 3 values
  class_buf<-names( which.max(table(train_buf$Species))) # check most frequent class
  out[i]<-class_buf # store result of classification
} 

sum(out==test_set_cl)/ n_test


## code is available at github
## check how accuracy changes as k changes

for (i in (1:10) )  {
  m1_knn<-knn( train=train_set[,-5],
               test=test_set,
               cl=train_set[,5], k=i,
               prob=TRUE)
  acc<-sum(m1_knn==test_set_cl)/ length(test_set_cl)
  print( paste( i,": Accuracy of ",  acc ) )
}




