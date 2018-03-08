library('dplyr')
library('mlogit')
library(caret)

####################################################################
########################estimated model##################################
######################################################################
chariot <- read.csv("chariotMNL.csv")
str(chariot)
chariot.logit <- mlogit.data(chariot, shape = "wide", varying = 2:7, choice = "mode", sep = "_")
# split the data into 80% train and 20% test 
n <- floor(3 * 0.75 * nrow(chariot))
train <- chariot.logit[1:n-1,]
test <- chariot.logit[n:nrow(chariot.logit),]
# str(train)
# str(test)
# built the MNLogit model using train data
# choose different mode as referrence mode, the coefficients of the reference mode are 0, so the utility of the 
# reference mode is also 0
# when choosing which mode as reference mode, we may need to consider how easy to find the significant variables, 
# to use as less as significant variables
# result <- mlogit(mode ~ time + cost + inctime + inccost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, method = "nr")
result <- mlogit(mode ~ time + cost | income + obr + dbr + age + veh, data = train, method = "nr", reflevel = "walk")
summary(result)

###########################################################################
# we can use different mode as reference level
########################################################################
result2 <- mlogit(mode ~ time + cost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, reflevel = "auto.passenger")
summary(result2)

result3 <- mlogit(mode ~ time + cost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, reflevel = "ride")
summary(result3)

result4 <- mlogit(mode ~ time + cost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, reflevel = "taxi")
summary(result4)

result5 <- mlogit(mode ~ time + cost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, reflevel = "transit")
summary(result5)

result6 <- mlogit(mode ~ time + cost | income + gender + obrookyln + dbrookyln + age + veh_num + FT_emply + HH.size, data = train, reflevel = "walk")
summary(result6)

# test model accuracy using test data
pred <- predict(result,newdata=test)
# head(pred)
# dim(pred)
a <- matrix(1, nrow=756,ncol = 1, dimnames = list(c(1:756),("result")))
pred <- cbind(pred,a)
head(pred)
# is.recursive(pred)
# is.atomic(pred)
# is.matrix(pred)
# compute prediction accuracy directly, the same as the above confusion matrix
for (i in 1:nrow(pred)){
        if(pred[i,1] > pred[i,2]){
                if(pred[i,1] > pred[i,3]){
                        pred[i,4] <- 'walk'
                }
                else pred[i,4] <- 'transit'
        }else if(pred[i,1] < pred[i,3]){
                if(pred[i,2] < pred[i,3]){
                        pred[i,4] <- 'transit'
                }
                else pred[i,4] <- 'auto'
        }else pred[i,4] <- 'auto'
        
}
misClasificError <- mean(pred[,4] != chariot[0.75 * nrow(chariot):nrow(chariot),]$mode)
print(paste('Accuracy',1-misClasificError))
# write.csv(pred, file = "chariot_pred.csv")
# the prediction accuracy rate is 61%

####################################################################
################################CV##################################
######################################################################
chariot <- read.csv("chariotMNL.csv")
str(chariot)
k.folds <- function(k) {
        folds <- createFolds(chariot$mode, k = k, list = TRUE, returnTrain = TRUE)
        for (j in 1:k) {
                chariot.logit <- mlogit.data(chariot[folds[[j]],], shape = "wide", varying = 2:7, choice = "mode", sep = "_")
                chariot.logit.test <- mlogit.data(chariot[-folds[[j]],], shape = "wide", varying = 2:7, choice = "mode", sep = "_")
                result <- mlogit(mode ~ time + cost | income + obr + dbr + age + veh, data = chariot.logit, method = "nr", reflevel = "walk")
                pred <- predict(result, newdata = chariot.logit.test)
                # nrow(pred)
                # nrow(chariot[-folds[[i]],])
                a <- matrix(1, nrow=nrow(pred),ncol = 1, dimnames = list(c(1:nrow(pred)),("result")))
                pred <- cbind(pred,a)
                for (i in 1:nrow(pred)){
                        if(pred[i,1] > pred[i,2]){
                                if(pred[i,1] > pred[i,3]){
                                        pred[i,4] <- 'walk'
                                }
                                else pred[i,4] <- 'transit'
                        }else if(pred[i,1] < pred[i,3]){
                                if(pred[i,2] < pred[i,3]){
                                        pred[i,4] <- 'transit'
                                }
                                else pred[i,4] <- 'auto'
                        }else pred[i,4] <- 'auto'
                }
                misClasificError <- mean(pred[,4] != chariot[-folds[[j]],]$mode)
                accuracies[j] <- 1-misClasificError
                print(paste('Accuracy',j,"is :",1-misClasificError))
        }
        accuracies
}

set.seed(500)
accuracies <- c() 
accuracies <- k.folds(10) 
mean(accuracies)
plot(accuracies)
# compare the estimated model with the result of CV to see if the accuracy of the estimated model is very
# different from CV result, if not, then the estimated model is reasonable.

