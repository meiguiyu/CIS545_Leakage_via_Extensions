library('dplyr')

df <- read.csv2(file="gravity.csv",  header=TRUE,sep=",")
str(df)

df$EST <- as.numeric(as.character(df[,11]))
df$H_income <- as.numeric(as.character(df[,3]))
df$H_POP <- as.numeric(as.character(df[,2]))
df$W_income <- as.numeric(as.character(df[,8]))
df$W_POP <- as.numeric(as.character(df[,7]))
df$distance <- as.numeric(as.character(df[,13]))

str(df)

result <- lm(log(EST) ~ log(H_income) + log(H_POP) + log(W_income) + log(W_POP) + log(distance), data = df,na.action="na.exclude")
summary(result)

