library(raster)
library(sp)
library(rgdal)
library(rnpn)
library(curl)
rm(list=ls())
setwd("~/Documents/My Files/USA-NPN/Data/Analysis/R_default/SIXV/FLI_Anomalies")

#Download 2019 NCEP raster for SI-x Leaf Anomaly - need to insert updated URL
curl_download("https://bit.ly/2uwUUkl", '2019si-x_leaf_anomaly_ncep.tif', quiet = FALSE, mode = "wb")  

#Download 1981-2018 SI-x Leaf Anomalies, using a loop
for(year in 1981:2018){
  npn_download_geospatial('si-x:leaf_anomaly_prism', paste0(year,'-01-01'),output_path=paste0(year,"si-x_leaf_anomaly_prism",".tif"))
}

#Call rasters from file names and set NA values with a stack for 1981-2018.
files <- list.files(getwd(),pattern="*m.tif") 
SIXA_stack <- stack(files) 
NAvalue(SIXA_stack) <- -9999
SIXA_stack
plot(SIXA_stack[[34:38]])

#Call the 2019 raster, set NA, resample to match the PRISM stack and plot to check.
SIXA19 <- raster("2019si-x_leaf_anomaly_ncep.tif")
NAvalue(SIXA19) <- -9999
SIXA19_4k <-resample(SIXA19, SIXA_stack, method='bilinear') 
plot(SIXA19_4k)

#Create an "On-time" 2019 raster where all on-time pixels are = to 1.
f <- function(r1)  ifelse(r1 == 0, 1, 0)
SIXA19_4k_OnTime<- overlay(SIXA19_4k, fun=f)
plot(SIXA19_4k_OnTime)

#Output the OnTime Raster for use in QGIS.
setwd("~/Documents/My Files/USA-NPN/Data/Analysis/R_default/SIXV/OutputRasters/CurrentY_DynRI/Leaf/")
writeRaster(SIXA19_4k_OnTime, "2019_Anom_OnTime_3-31.tiff", format="GTiff",  overwrite=TRUE, NAflag=-9999) 

#Create an "Early" 2019 raster where all late or on-time pixels are null.
f <- function(r1)  ifelse(r1 <= -0.0000001, r1,  NA)
SIXA19_4k_Early<- overlay(SIXA19_4k, fun=f)
plot(SIXA19_4k_Early)

#Create a "Late" 2019 raster where all early or on-time pixels are null.
f <- function(r1)  ifelse(r1 >= 0.00000001, r1,  NA)
SIXA19_4k_Late<- overlay(SIXA19_4k, fun=f)
plot(SIXA19_4k_Late)

#Early Return Interval, Step 1: create overlays where 1 = spring in X year was as early or earlier than 2019, otherwise 0.
f <- function(r1, r2)  ifelse(r1 <= r2, 1,  0)
SIXA_stack_Earlier<- overlay(SIXA_stack, SIXA19_4k_Early, fun=f)

#Plot example earlier than 2019 map to check.
plot(SIXA_stack_Earlier[[15]],
     main="Where X Year As Early or Earlier than 2019")

#Early RI Step 2: Count how many time each pixel was earlier than 2019 over the period.
SIXA_Earlier_count <-sum(SIXA_stack_Earlier)
plot(SIXA_Earlier_count)

#Early RI - Step 3, divide count raster by 38 to create Return Interval raster.
f <- function(r1)  ifelse(r1 == 0, r1,  38/r1)
RI_Early<- overlay(SIXA_Earlier_count, fun=f)
plot(RI_Early)

#Output the raster of the Return interval 
writeRaster(RI_Early, "2019_RI_Early_Leaf.tiff", format="GTiff", overwrite=TRUE, NAflag=-9999)

#Late Return Interval, Step 1: create overlays where 1 = spring in X year was as late or later than 2019, otherwise 0.
f <- function(r1, r2)  ifelse(r1 >= r2, 1,  0)
SIXA_stack_Later<- overlay(SIXA_stack, SIXA19_4k_Late, fun=f)

#Plot example earlier than 2019 map to check.
plot(SIXA_stack_Later[[8]],
     main="Where X Year As Late or Later than 2019")

#Late RI Step 2: Count how many time each pixel was later than 2019 over the period.
SIXA_Later_count <-sum(SIXA_stack_Later)
plot(SIXA_Later_count)

#Late RI - Step 3, divide count raster by 38 to create Return Interval raster.
f <- function(r1)  ifelse(r1 == 0, r1,  38/r1)
RI_Late<- overlay(SIXA_Later_count, fun=f)
plot(RI_Late)

#Output the raster of the Return interval 
writeRaster(RI_Late, "2019_RI_Late_Leaf.tiff", format="GTiff",overwrite=TRUE, NAflag=-9999)