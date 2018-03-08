
########
# REMEMBER TO CHECK IF THERE IS NA OR BLANK DATA BEFORE YOU DO ANY PROCESS 
# REMOVE THOSE NA OR BLANK DATA BEFORE YOU DO VISUALIZATION
#########
library(dplyr)
library(ggplot2)
library(leaflet)
library('ggthemes')
library(ggmap)
library(htmlwidgets)

total_demand <- read.csv(file="MandB_tract_flows1.csv",  header=TRUE)
str(total_demand)

fit_data <- read.csv(file="data-10.23 - Copy.csv",  header=TRUE)
# head(fit_data)
fit_data <- fit_data %>%
        filter(modename != 'auto-passenger')

#age,gender to PMODE
fit_data$genderD[fit_data$gender == 1] <- 'Female'
fit_data$genderD[fit_data$gender == 0] <- 'Male'

# mosaicplot(table(fit_data$genderD, fit_data$modename), main='Family Size by Survival', shade=TRUE)

#density distribution of EST
ggplot(total_demand[total_demand$different_tract == 0, ], 
       aes(x = EST)) +
        geom_density(fill = '#99d6ff', alpha=0.4) + 
        geom_vline(aes(xintercept=median(EST, na.rm=T)),
                   colour='black', linetype='dashed', lwd=1) +
        theme_few()

# plot the relationship between gender, age and pmode
ggplot(fit_data, aes(age, fill = factor(genderD))) + 
        geom_histogram() + 
        # I include Sex since we know (a priori) it's a significant predictor
        facet_grid(.~modename) +
        theme_few()

# use this to plot the number of tract flow in each level census tract
# first, for EST happen in the same tract(e.g.EST>300, EST<100)
# then for EST happen in different tract(e.g.EST>300, EST<100), but there is one
# problem, how to plot the H coordinates and W coordinates??



tmp_sam_tract <- total_demand %>% 
        filter(different_tract == 0) %>% 
        filter(EST >= 300) %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon) 

tmp_sam_tract1 <- total_demand %>% 
        filter(different_tract == 0) %>% 
        filter(EST < 300) %>% 
        filter(EST >= 200) %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon) 

tmp_sam_tract2 <- total_demand %>% 
        filter(different_tract == 0) %>% 
        filter(EST <200) %>% 
        filter(EST >=100) %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon)

# plot the tracts have more than 300 tract flows in the same tracts
a = leaflet(tmp_sam_tract) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircleMarkers(stroke=FALSE,label = ~as.character(EST)) %>%
        # addCircleMarkers(~tmp_sam_tract1$lon, ~tmp_sam_tract1$lat, color="red") %>%
        addMiniMap()

saveWidget(a, file="same_tract_over300.html")

e = leaflet(tmp_sam_tract) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircleMarkers(stroke=FALSE,label = ~as.character(EST),color = "black") %>%
        addCircleMarkers(~tmp_sam_tract1$lon, ~tmp_sam_tract1$lat, color="yellow", label = ~as.character(tmp_sam_tract1$EST)) %>%
        addMiniMap()

saveWidget(e, file="same_tract_morethan200.html")

g = leaflet(tmp_sam_tract2) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircleMarkers(stroke=FALSE,label = ~as.character(EST),color = "black") %>%
        addCircleMarkers(~tmp_sam_tract2$lon, ~tmp_sam_tract2$lat, color="blue", label = ~as.character(tmp_sam_tract2$EST)) %>%
        addMiniMap()

saveWidget(g, file="same_tract_100to200.html")

#######################################################################
# plot the a certain point location
data <- data.frame(lat=c(40.81851,40.56499,40.76348,40.76078),lon=c(-73.9463,-74.0190,-73.9673,-73.9777))

c = leaflet() %>%
        addProviderTiles("Esri.NatGeoWorldMap") %>%
        addCircleMarkers(-74.018973,40.7087093) %>%
        # addPolylines(data = data, lng = ~ lon, lat = ~ lat) %>%
        addMiniMap()

# saveWidget(c, file="dff_tract_over300_area.html")
####################################################################
# link two points on the map use a line, EST > 300, different tracts
df <- total_demand %>%
        filter(different_tract == 1)%>%
        filter(EST >= 300)

df1 <- total_demand %>%
        filter(different_tract == 1)%>%
        filter(EST >= 250) %>%
        filter(EST < 300)

df2 <- total_demand %>%
        filter(different_tract == 1)%>%
        filter(EST < 250) %>%
        filter(EST >= 200)

## constrcut the points data
dfpoint <- df %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon) 
dfpoint1 <- df %>% 
        select(EST,W_ALTITUDE,W_LONGITUDE) %>%
        mutate(lon1=W_LONGITUDE,lat1=W_ALTITUDE) %>% 
        select(EST,lat1,lon1) 

df1point <- df1 %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon) 
df1point1 <- df1 %>% 
        select(EST,W_ALTITUDE,W_LONGITUDE) %>%
        mutate(lon1=W_LONGITUDE,lat1=W_ALTITUDE) %>% 
        select(EST,lat1,lon1) 

df2point <- df2 %>% 
        select(EST,H_ALTITUDE,H_LONGITITUDE) %>%
        mutate(lon=H_LONGITITUDE,lat=H_ALTITUDE) %>% 
        select(EST,lat,lon) 
df2point1 <- df2 %>% 
        select(EST,W_ALTITUDE,W_LONGITUDE) %>%
        mutate(lon1=W_LONGITUDE,lat1=W_ALTITUDE) %>% 
        select(EST,lat1,lon1) 

## plot the coordinates as points on the map
g = leaflet(dfpoint) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        # fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircles() %>%
        addCircles(~dfpoint1$lon1,~dfpoint1$lat1)

g1 = leaflet(df1point) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        # fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircles() %>%
        addCircles(~df1point1$lon1,~df1point1$lat1)

g2 = leaflet(df2point) %>% 
        addProviderTiles("Esri.NatGeoWorldMap") %>% 
        # fitBounds(lon[1],lat[1],lon[2],lat[2]) %>% 
        addCircles() %>%
        addCircles(~df2point1$lon1,~df2point1$lat1)


# d = leaflet(df)%>% 
#         addProviderTiles("Esri.NatGeoWorldMap") 
#                 
# e = leaflet(df1)%>%
#         addProviderTiles("Esri.NatGeoWorldMap") 
# 
# f = leaflet(df2)%>%
#         addProviderTiles("Esri.NatGeoWorldMap")
#################################################################33
## add lables when mouse hover over
labels <- sprintf(
        "<strong>Tract flows is: %s</strong><br/>From %s TRACT %g to %s TRACT %g",
        df$EST, df$HN,df$H,df$WN,df$W ) %>% lapply(htmltools::HTML)

labels1 <- sprintf(
        "<strong>Tract flows is: %s</strong><br/>From %s TRACT %g to %s TRACT %g",
        df1$EST, df1$HN,df1$H,df1$WN,df1$W ) %>% lapply(htmltools::HTML)

labels2 <- sprintf(
        "<strong>Tract flows is: %s</strong><br/>From %s TRACT %g to %s TRACT %g",
        df2$EST, df2$HN,df2$H,df2$WN,df2$W ) %>% lapply(htmltools::HTML)

## assign the g map to d map
for(i in 1:nrow(df)){
             d <-   addPolylines(g, lat = as.numeric(df[i, c(4, 9)]), 
                         lng = as.numeric(df[i, c(5, 10)]),weight = 5,
                         opacity = 0.5,
                         color = "blue",
                         dashArray = "3",
                         fillOpacity = 1,
                         highlight = highlightOptions(
                                 weight = 5,
                                 color = "red",
                                 dashArray = "",
                                 fillOpacity = 0.7,
                                 bringToFront = TRUE), label =labels[[i]]) 
}
## plot the lines on d map
for(i in 1:nrow(df)){
        d <-   addPolylines(d, lat = as.numeric(df[i, c(4, 9)]), 
                            lng = as.numeric(df[i, c(5, 10)]),weight = 5,
                            opacity = 0.5,
                            color = "blue",
                            dashArray = "3",
                            fillOpacity = 1,
                            highlight = highlightOptions(
                                    weight = 5,
                                    color = "red",
                                    dashArray = "",
                                    fillOpacity = 0.7,
                                    bringToFront = TRUE), label =labels[[i]]) 
}
saveWidget(d, file="0dff_over300.html")

## assign g1 map to e map
for(i in 1:nrow(df1)){
        e <- addPolygons(g1, lat = as.numeric(df1[i, c(4, 9)]), 
                             lng = as.numeric(df1[i, c(5, 10)]),weight = 4,
                         opacity = 0.5,
                         color = "blue",
                         dashArray = "3",
                         fillOpacity = 1,
                         highlight = highlightOptions(
                                 weight = 5,
                                 color = "red",
                                 dashArray = "",
                                 fillOpacity = 0.7,
                                 bringToFront = TRUE), label = labels1[[i]])
}
## plot the lines on e map
for(i in 1:nrow(df1)){
        e <- addPolygons(e, lat = as.numeric(df1[i, c(4, 9)]), 
                         lng = as.numeric(df1[i, c(5, 10)]),weight = 4,
                         opacity = 0.5,
                         color = "blue",
                         dashArray = "3",
                         fillOpacity = 1,
                         highlight = highlightOptions(
                                 weight = 5,
                                 color = "red",
                                 dashArray = "",
                                 fillOpacity = 0.7,
                                 bringToFront = TRUE), label = labels1[[i]])
}
saveWidget(e, file="0dff_200to300.html")

## assign g2 map to f map
for(i in 1:nrow(df2)){
        f <- addPolygons(g2, lat = as.numeric(df2[i, c(4, 9)]), 
                         lng = as.numeric(df2[i, c(5, 10)]),weight = 4,
                         opacity = 0.5,
                         color = "blue",
                         dashArray = "3",
                         fillOpacity = 1,
                         highlight = highlightOptions(
                                 weight = 5,
                                 color = "red",
                                 dashArray = "",
                                 fillOpacity = 0.7,
                                 bringToFront = TRUE), label = labels2[[i]])
}
## plot lines on f map
for(i in 1:nrow(df2)){
        f <- addPolygons(f, lat = as.numeric(df2[i, c(4, 9)]), 
                         lng = as.numeric(df2[i, c(5, 10)]),weight = 4,
                         opacity = 0.5,
                         color = "blue",
                         dashArray = "3",
                         fillOpacity = 1,
                         highlight = highlightOptions(
                                 weight = 5,
                                 color = "red",
                                 dashArray = "",
                                 fillOpacity = 0.7,
                                 bringToFront = TRUE), label = labels2[[i]])
}
saveWidget(f, file="0dff_lessthan200.html")

