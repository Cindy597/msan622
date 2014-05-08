

loadData <- function(){
  data<-read.csv("merged_dress_sales.csv")
  colnames(data)<-c("Dress_ID","08/02","08/04","08/06","08/08","08/10","08/12","08/14","08/16",
                    "08/18","08/20","08/22","08/24","08/26","08/28","08/30","09/02","09/04",
                    "09/06","09/08","09/10","09/12","09/14","09/16","09/18","09/20","09/22",
                    "09/24","09/26","09/28","09/30","10/02","10/04","10/06","10/08","10/10","10/12","10/14",
                    "10/16","10/18","10/20","10/22","10/24","10/26","10/28","10/30","Style","Price",
                    "Rating","Size","Season","NeckLine","SleeveLength","waiseline","Material","FabricType",
                    "Decoration","Pattern.Type","Recommendation")
  return(data)
}
mydata<-loadData()
data<-na.omit(mydata)
data<-data[!(is.na(data$Season) | data$Season==""), ]
data<-data[!(is.na(data$Material) | data$Material=="" |data$Material==" "), ]
mydata<-data
mydata<-mydata[,47:ncol(mydata)]


############ change several variables to nuericcal
mydata$Style<-as.character(mydata$Style)
mydata$Style[mydata$Style=='bohemian']<-1
mydata$Style[mydata$Style=='Brief']<-2
mydata$Style[mydata$Style=='Casual']<-3
mydata$Style[mydata$Style=='cute']<-4
mydata$Style[mydata$Style=='fashion']<-5
mydata$Style[mydata$Style=='Flare']<-6
mydata$Style[mydata$Style=='Novelty']<-7
mydata$Style[mydata$Style=='OL']<-8
mydata$Style[mydata$Style=='party']<-9
mydata$Style[mydata$Style=='sexy']<-10
mydata$Style[mydata$Style=='Sexy']<-11
mydata$Style[mydata$Style=='vintage']<-12
mydata$Style[mydata$Style=='work']<-13

mydata$Price<-as.character(mydata$Price)
mydata$Price[mydata$Price=="Average"]<-1
mydata$Price[mydata$Price=="high" | mydata$Price=="High"]<-2
mydata$Price[mydata$Price=="low" | mydata$Price=="Low"]<-3
mydata$Price[mydata$Price=="Medium"]<-4
mydata$Price[mydata$Price=="very-high"]<-5

mydata$waiseline <-as.character(mydata$waiseline)
mydata$waiseline[mydata$waiseline=="dropped"]<-1
mydata$waiseline[mydata$waiseline=="empire"]<-2
mydata$waiseline[mydata$waiseline=="natural"]<-3
mydata$waiseline[mydata$waiseline=="princess"]<-4
mydata$waiseline[mydata$waiseline=="null"]<-5


mydata$Size<-as.character(mydata$Size)
mydata$Size[mydata$Size=="free"]<-1
mydata$Size[mydata$Size=="L"]<-2
mydata$Size[mydata$Size=="M"]<-3
mydata$Size[mydata$Size=="s" |mydata$Size=="S" |mydata$Size=="small" ]<-4
mydata$Size[mydata$Size=="XL"]<-5

mydata$Season<-as.character(mydata$Season)
mydata$Season[mydata$Season=="Automn" | mydata$Season=="Autumn"]<-1
mydata$Season[mydata$Season=="spring" | mydata$Season=="Spring"]<-2
mydata$Season[mydata$Season=="summer" | mydata$Season=="Summer"]<-3
mydata$Season[mydata$Season=="winter" | mydata$Season=="Winter"]<-4
mydata$Season[mydata$Season=="NA"]<-5


mydata$Material<-as.character(mydata$Material)
mydata$Material[mydata$Material=="mix"]<-1
mydata$Material[mydata$Material=="cotton"]<-2
mydata$Material[mydata$Material=="knitting"]<-3
mydata$Material[mydata$Material=="lace"]<-4
mydata$Material[mydata$Material=="silk" | mydata$Material=="milksilk"]<-5
mydata$Material[mydata$Material=="null"]<-6
mydata$Material[mydata$Material=="chiffonfabric"]<-7
mydata$Material[mydata$Material=="viscos"]<-8
mydata$Material[mydata$Material=="polyster"]<-9
mydata$Material[mydata$Material=="rayon"]<-10
mydata$Material[mydata$Material=="cashmere"]<-11
mydata$Material[mydata$Material=="microfiber"]<-12
mydata$Material[mydata$Material=="acrylic"]<-13
mydata$Material[mydata$Material=="nylon"]<-14
mydata$Material[mydata$Material=="wool"]<-15
mydata$Material[mydata$Material=="modal"]<-16
mydata$Material[mydata$Material=="model"]<-17
mydata$Material[mydata$Material=="spandex"]<-18
mydata$Material[mydata$Material=="linen"]<-19
mydata$Material[mydata$Material=="lycra"]<-20
mydata$Material[mydata$Material=="other"]<-21



mydata$SleeveLength<-as.character(mydata$SleeveLength)
mydata$SleeveLength[mydata$SleeveLength=="sleevless" | mydata$SleeveLength=="sleeevless" | 
                      mydata$SleeveLength=="sleeveless" | mydata$SleeveLength=="sleveless"]<-1
mydata$SleeveLength[mydata$SleeveLength=="halfsleeve" |mydata$SleeveLength=="half" ]<-2
mydata$SleeveLength[mydata$SleeveLength=="full"]<-3
mydata$SleeveLength[mydata$SleeveLength=="capsleeves" | mydata$SleeveLength=="cap-sleeves"]<-4
mydata$SleeveLength[mydata$SleeveLength=="short"]<-5
mydata$SleeveLength[mydata$SleeveLength=="thressqatar" | mydata$SleeveLength=="threequarter"| mydata$SleeveLength=="threequater" ]<-6
mydata$SleeveLength[mydata$SleeveLength=="urndowncollor" |mydata$SleeveLength=="butterfly" |mydata$SleeveLength=="NULL" |
                      mydata$SleeveLength=="Petal" ]<-7


mydata$NeckLine<-as.character(mydata$NeckLine)
mydata$NeckLine[mydata$NeckLine=="o-neck"]<-1
mydata$NeckLine[mydata$NeckLine=="v-neck"]<-2
mydata$NeckLine[mydata$NeckLine=="boat-neck"]<-3
mydata$NeckLine[mydata$NeckLine=="bowneck"]<-4
mydata$NeckLine[mydata$NeckLine=="slash-neck"]<-5
mydata$NeckLine[mydata$NeckLine=="Sweetheart"]<-6
mydata$NeckLine[mydata$NeckLine=="turndowncollor"]<-7
mydata$NeckLine[mydata$NeckLine=="peterpan-collor"]<-8
mydata$NeckLine[mydata$NeckLine=="ruffled" |mydata$NeckLine=="Scoop" |
                  mydata$NeckLine=="open" | mydata$NeckLine=="mandarin-collor"]<-9




mydata$FabricType<-as.character(mydata$FabricType)
mydata$FabricType[mydata$FabricType=="chiffon"]<-1
mydata$FabricType[mydata$FabricType=="null"]<-2
mydata$FabricType[mydata$FabricType=="worsted"]<-3
mydata$FabricType[mydata$FabricType=="broadcloth"]<-4
mydata$FabricType[mydata$FabricType=="sattin"]<-5
mydata$FabricType[mydata$FabricType=="jersey"]<-6
mydata$FabricType[mydata$FabricType=="dobby"]<-7
mydata$FabricType[mydata$FabricType=="shiffon"]<-8
mydata$FabricType[mydata$FabricType=="knitting" | mydata$FabricType=="knitted"]<-9
mydata$FabricType[mydata$FabricType=="poplin"]<-10
mydata$FabricType[mydata$FabricType=="terry" | mydata$FabricType=="wollen" | mydata$FabricType=="organza" |
                    mydata$FabricType=="Corduroy" |mydata$FabricType=="tulle" | mydata$FabricType=="other"]<-11


mydata$Decoration<-as.character(mydata$Decoration)
mydata$Decoration[mydata$Decoration=='null']<-1
mydata$Decoration[mydata$Decoration=="beading"]<-2
mydata$Decoration[mydata$Decoration=="lace"]<-3
mydata$Decoration[mydata$Decoration=="bow"]<-4
mydata$Decoration[mydata$Decoration=="sashes"]<-5
mydata$Decoration[mydata$Decoration=="hollowout"]<-6
mydata$Decoration[mydata$Decoration=="ruffles"]<-7
mydata$Decoration[mydata$Decoration=="sequined"]<-8
mydata$Decoration[mydata$Decoration=="applique"]<-9
mydata$Decoration[mydata$Decoration== "pockets"]<-10
mydata$Decoration[mydata$Decoration=="feathers"]<-11
mydata$Decoration[mydata$Decoration=="draped" |mydata$Decoration=="tassel"| mydata$Decoration=="flowers" |
                    mydata$Decoration=="none" | mydata$Decoration=="crystal"| mydata$Decoration=="plain"|
                    mydata$Decoration=="embroidary" | mydata$Decoration=="rivet" | mydata$Decoration=="cascading"|
                    mydata$Decoration=="pearls"]<-12




mydata$Pattern.Type<-as.character(mydata$Pattern.Type)
mydata$Pattern.Type[mydata$Pattern.Type=="solid"]<-1
mydata$Pattern.Type[mydata$Pattern.Type=="null"]<-2
mydata$Pattern.Type[mydata$Pattern.Type=="patchwork"]<-3
mydata$Pattern.Type[mydata$Pattern.Type=="print"]<-4
mydata$Pattern.Type[mydata$Pattern.Type=="animal"]<-5
mydata$Pattern.Type[mydata$Pattern.Type=="striped"]<-6
mydata$Pattern.Type[mydata$Pattern.Type== "dot"]<-7
mydata$Pattern.Type[mydata$Pattern.Type=="plaid"]<-8
mydata$Pattern.Type[mydata$Pattern.Type== "leopard" | mydata$Pattern.Type== "none" | mydata$Pattern.Type== "geometric"]<-9



data_new<-mydata
data_new<-na.omit(data_new)

for (i in 1:ncol(data_new)){
  data_new[,i]<- as.numeric(data_new[,i])
}

library(MASS)
library(randomForest)
modelpure <- randomForest(as.factor(Recommendation) ~., data=data_new,importance=TRUE, ntree=500,sampsize=nrow(data_new), nodesize=1)
imp<-importance(modelpure,type=1)
#plot(imp)
#MeanDecreaseAccuracy<-imp[,3]

#MeanDecreaseGini<-imp[,4]
#my_result<-cbind(sort(MeanDecreaseAccuracy),rownames(as.data.frame(sort(MeanDecreaseAccuracy))))
#colnames(my_result)<-c("MeanDecreaseAccuracy","variables")
#plot(my_result[,1],my_result[,2]) 
varImpPlot(modelpure,main=" Average Importance plots",col="purple")
#varImpPlot(modelpure,class="Yes",main=" Class= Yes Importance plots",col="purple")
#partialPlot(modelpure, data_new,Sep_10, "1",main="For the yes category")




