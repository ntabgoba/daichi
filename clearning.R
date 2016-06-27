# JAEA Data Analysis, Fukushima, Fish_Strontium, DrinkingWater, FoodProducts, Rice_Radioactive,WildBirds_Animals_Radioactivity 

# One becquerel is defined as the activity of a quantity of radioactive material in which one nucleus decays per second.
# The becquerel is therefore equivalent to an inverse second, 1/s
# Example,The nuclear explosion in Hiroshima (An explosion of 16 kt or 67 TJ) is estimated to have produced 8×1024 Bq (8 YBq, 8 yottabecquerel)

'''
Due to the nature of the Fukushima Daichi releases, the major contaminants were isotopes of volatile elements: 
Iodine-131 (8 day half-life), Tellurium-132 (3 day half-life), Cesium-134 (2 year half-life), 
and Cesium-137 (30 year half-life) [Steinhauser et al. 2014].
Because of the relatively short half-lives of 131I and 132Te, by 2014 these isotopes have 
completely decayed away. This leaves 134Cs and 137Cs as the largest components of the initial 
radioactive releases that could also still be in the environment. 
The last piece of the puzzle is the ratio of 134Cs to 137Cs: it was approximately 0.9 in March 2011 [Kirchner et al. 2012]

MEASUREMENTS
1.Radiation emitted by a radioactive material (measured in units like curies and becquerels)
2.Radiationenergy absorbed by a mass of material (measured in rad or gray), 
3.Relative biological damage in the human body (using rem and sieverts), which depends on the type of radiation.
'''

library(ggplot2)
library(dplyr)
library(readr)

fish1 <- read_csv("Fisheries_Products_Strontium_2011.csv",na = "ND")
water1 <- read_csv("Fukushima_DrinkingWater_2011-14.csv",na = "ND")
food1 <- read_csv("Fukushima_FoodProducts_2011-today.csv", na = "ND")
rice1 <- read_csv("Fukushima_Rice_Radioactive_Cesium_2011Aug_Nov.csv", na="ND")
birds1 <- read_csv("Fukushima_WildBirds_Animals_Radioactivity_2011.csv", na="ND")
View(fish1)

# POSSIBLE QUESTIONS OF CURIOSITY?
# What is the comparison of "Radioactivity", water-fish-rice-birds per;
# 1.date, 2; One city e.g Nihomatsu,  3.Geographically, 4.Distance from TEPCO
# FOOD
View(food1)
dim(food1) # 128402     46
unique(food1$Item) #2308 unique food items
unique(food1$`Food category`) # 9 Foot Categories
unique(food1$`Origin (municipality)`) # Origin Municipality = 64
food <- select(food1, c(26,6,20,22,29,31,33))
colnames(food) <- c("date","origin_municplty","food_categ","item","Iodine_131","Cesium_134", "Cesium_137")

#Plots
ggplot(data = food1)+
        geom_point(mapping = aes(x= date, y = Iodine_131, na.rm = TRUE))+
        geom_point(mapping = aes(x= date, y = Cesium_134, na.rm = TRUE), shape = 23)+
        geom_point(mapping = aes(x= date, y = Cesium_137, na.rm = TRUE),shape = 19,color = "red")

max(food$Iodine_131,na.rm = TRUE) #22000
mean(food$Iodine_131,na.rm = TRUE) # 622.6173

max(food$Cesium_134,na.rm = TRUE) #41000
mean(food$Cesium_134,na.rm = TRUE) #74.87766
max(food$Cesium_137,na.rm = TRUE) #41000
mean(food$Cesium_137,na.rm = TRUE) #59.38759

#remove the first peak radiations of 2011
food2 <- filter(food, Iodine_131 < 22000,  Cesium_134 < 41000,  Cesium_137 < 41000)

#rename the Meat/Chiken/Raw milk value
food2$food_categ[food2$food_categ == "Meat/Chiken/Raw milk"] <- "meatChickenMilk"
food2$food_categ <- as.factor(food2$food_categ)
unique(food2$food_categ)

ggplot(data = food2)+
        geom_point(mapping = aes(x= date, y = Iodine_131, color=food_categ,na.rm = TRUE))+
        geom_point(mapping = aes(x= date, y = Cesium_134, color=food_categ, na.rm = TRUE), shape = 23)+
        geom_point(mapping = aes(x= date, y = Cesium_137, color=food_categ, na.rm = TRUE),shape = 19)

ggplot(data = food2)+
        geom_bar(stat="identity",mapping = aes(x= date, y = Iodine_131,fill=food_categ, na.rm = TRUE))+
        geom_bar(stat="identity",mapping = aes(x= date, y = Cesium_134,fill=food_categ, na.rm = TRUE))+
        geom_bar(stat="identity",mapping = aes(x= date, y = Cesium_137, fill=food_categ,na.rm = TRUE))
write_csv(x=food2, path = "food2.csv")
foodx <- read_csv("food2.csv")
View(foodx)

#FISH
# Select and rename preliminary features
View(fish1)
unique(fish1$`Type of sample`) # 43 Fish Types
fishe <- select(fish1,c(1,4,5,6,8,10,12,14))
colnames(fishe) <- c("date","lat","lng","daichi_distance","Iodine_131","Cesium_134","Cesium_137","Cesium_134_Plus_Cesium_137C")
View(fishe)
fishes <- transmute(fishe,date,lat,lng,daichi_distance,Iodine_131,Cesium_134,Cesium_137,Cesium_134_Plus_Cesium_137C = Cesium_134 + Cesium_137)
View(fishes)
#EXPLORATORY ANALYSIS
rbind(min(fishes$Cesium_134,na.rm=TRUE),max(fishes$Cesium_134,na.rm=TRUE),mean(fishes$Cesium_134,na.rm=TRUE))
fish <- filter(fishes, Cesium_134 < 390)
View(fish)
write_csv(x=fish,path = "fish2.csv")
# Variability with time
ggplot(data = fish,mapping = aes(x = date, y = Cesium_134,na.rm = TRUE))+
        geom_point(shape = 16)+
        geom_smooth(se=TRUE)+
        geom_point(mapping = aes(x = date, y = Cesium_137, na.rm = TRUE), color="red", shape = 17)+
#bar graphs 
ggplot(data = fish,mapping = aes(x = date, y = Cesium_134, na.rm = TRUE))+
        geom_bar(stat="identity", color = "blue")
ggplot(data = fish,mapping = aes(x = date, y = Cesium_137, na.rm = TRUE))+
        geom_bar(stat="identity", color = "red")

#3 D
library(plotly)
plot_ly(data = fish, z = Cesium_134, x = daichi_distance, y = Cesium_137, type = "scatter3d",mode = "markers")

# WATER
water <- select(water1,c(1,9,10,11,12,14,16))
colnames(water) <- c("date","lat","lng","daichi_distance","Iodine_131","Cesium_134", "Cesium_137")
ggplot(data = water,mapping = aes(x = date, y = Iodine_131, na.rm = TRUE))+
        geom_point(shape = 16) #Radiations appeared in drinking water in only the first few days
View(water)
#assuming NAs are zero or negligible 
water[is.na(water)] <- 0
water1 <- as_data_frame(water)
write_csv(water1, path = "water2.csv")

# RICE
View(rice1)
rice <- select(rice1,c(1,3,6))
colnames(rice) <- c("date","city","Cesium_134_Plus_Cesium_137")
ggplot(data = rice)+
        geom_point(mapping = aes(x = date, y = Cesium_134_Plus_Cesium_137,na.rm = TRUE))
View(rice)
write_csv(x=rice, path = "rice2.csv")

#BIRDS and Animals
View(birds1)
birds <- select(birds1, c(8,3,4,7,14))
colnames(birds) <- c("date","origin_district","origin_municplty","item","Cesium_134_Plus_Cesium_137")
View(birds)
unique(birds$item) # 7types of animals/birds
ggplot(data=birds)+
        geom_point(mapping = aes(x=date, y = Cesium_134_Plus_Cesium_137, color= item, na.rm =TRUE))
birds <- na.omit(birds2)
write_csv(x=birds, path = "birds2.csv")
#End 
