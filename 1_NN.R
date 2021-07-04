
# upload libraries
library(dplyr) # wrangling
library(tidyr) # wrangling
library(tibble) # wrangling
library(ggplot2) # visuals
library(gridExtra) # visuals
library(rpart.plot) # visuals
library(readxl) # file interface
library(forecast) # modeling
library(rpart)  # modeling
library(caret)  # modeling
library(neuralnet) # modeling

#  remove variables after previous code run
rm(list=ls()) 

#  set working directory
setwd("C:\\Users\\LENOVO\\Desktop\\SubscribeMyChannel")
getwd()

# upload data
d1<-readxl::read_excel( "housing.xlsx" )

# explore dataset
View(d1)
str(d1)
summary(d1)

# RM - average number of rooms per dwelling
# LSTAT - % of lower status  population
# PTRATIO - pupil-teacher ratio by town
# MEDV - Median value of homes 

# rename class column to "y"
d1_dummy<- d1 %>% dplyr::rename( y=MEDV )


        ######      normalize and denormalize input 

# normalization
normalize <- function(x) {
  maxval<<-max(x) # global assignment operator
  minval<<-min(x) # global assignment operator
  return ((x -minval) / (maxval -minval))
}

# denormalization
denormalize <- function(x) {
  return( x*(maxval-minval) + minval )
}


# normalize data.frame( tibble )  
ddnorm <- lapply(d1_dummy,normalize) %>% as_tibble()

# create formula
f <- as.formula(paste( "y", paste( names(ddnorm)[ -ncol(ddnorm) ], collapse = " + ") ,sep=" ~ " )  )


# train neural network
m_4_f<-neuralnet::neuralnet( f,data=ddnorm, #  formula and dataset
                             hidden=c(2,1), # topology, 2 layers, with 2 and 1 nodes 
                             rep=5, # 5  reps to train model
                             err.fct="sse", # sum of squared errors
                             act.fct= 'logistic'  ) # activation function as logistic
class(m_4_f) # check class

plot(m_4_f,rep="best")  # plot nn

# extract fitted values
m_4_pred<-predict(m_4_f,newdata=ddnorm) %>% sapply(denormalize) 

neuralnet::compute # Press F1 after function name

# use ggplot for visuals
gg_input<-tibble(Predict=m_4_pred,Actual=d1_dummy$y)
ggplot( data=gg_input)+geom_point( aes(y=Predict,x=1:nrow(gg_input)),col="red" )+
                geom_point( aes(y=Actual,x=1:nrow(gg_input)),col="blue" )+
          geom_smooth( aes(y=Predict,x=1:nrow(gg_input)),method="loess",formula = y ~ x,col="red" )+
          geom_smooth( aes(y=Actual,x=1:nrow(gg_input)),method="loess",formula = y ~ x,col="blue" )

with(gg_input, cor(Predict,Actual)  ) # correlation

plot(m_4_pred,col="blue") 
points(d1_dummy$y,col="red")  


# summary measures of the forecast accuracy
forecast::accuracy(m_4_pred,x=d1_dummy$y)


######################################

m_4_f<-neuralnet::neuralnet( f,data=ddnorm, 
                             hidden=c(3,2,1), 
                             rep=5, 
                             err.fct="sse", 
                             act.fct= 'logistic'  ) 

plot(m_4_f,rep="best") 

m_4_pred<-predict(m_4_f,newdata=ddnorm) %>% sapply(denormalize)

gg_input<-tibble(Predict=m_4_pred,Actual=d1_dummy$y)
ggplot( data=gg_input)+geom_point( aes(y=Predict,x=1:nrow(gg_input)),col="red" )+
  geom_point( aes(y=Actual,x=1:nrow(gg_input)),col="blue" )+
  geom_smooth( aes(y=Predict,x=1:nrow(gg_input)),method="loess",formula = y ~ x,col="red" )+
  geom_smooth( aes(y=Actual,x=1:nrow(gg_input)),method="loess",formula = y ~ x,col="blue" )

forecast::accuracy(m_4_pred,x=d1_dummy$y)






