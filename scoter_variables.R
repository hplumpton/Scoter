library(rgdal)
library(maps)
library(raster)
library(maptools)

bathy=raster("Layers/etopo1 bathymetry.tif")
image(bathy)
summary(bathy)

scoters=read.csv("ObsData2.csv",header=TRUE)
scoters <-na.omit(scoters)
summary(scoters)

coordinates(scoters)<-c("longitude_dd","latitude_dd") #define x&y coordinates
proj4string(scoters)<-CRS("+init=epsg:4326") #assigning a projection
plot(scoters,add=TRUE)

sco2=spTransform(scoters,CRS(proj4string(bathy))) #assign same projection as bathy
map("state", add=TRUE)

sco3=SpatialPoints(sco2) #extract function didn't like SpatialPointsDataFrame
sco2$bathy=extract(bathy,sco3) 
#extract bathymetry measure at each spatial location combined with scoters data
sco2$bathy2=scale(sco2$bathy) 
#standardize covariates for comparison of beta estimates later on
head(sco2)

substrate=readShapePoly("Layers/substrate/conmapsg.shp")
image(substrate)
dim(substrate)
help("image.default")
summary(substrate)

proj4string(bathy)
sub<- spTransform(substrate, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#assigned same projection as bathy
head(substrate)

scotsubtr=SpatialPoints(sco2)
sco2$sub=extract(sub,scotsubtr)
#extract substrate measure at each spatial laoction combined with scoters data
sco2$sub2=scale(sco2$sub)
#standardize covariates for comparison of beta estimates later on
