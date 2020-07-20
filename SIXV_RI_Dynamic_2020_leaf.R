library(raster)
library(sp)
library(rgdal)
library(rnpn)
rm(list=ls())
setwd("~/Documents/My Files/USA-NPN/Data/Analysis/R_default/SIXV/FLI_Anomalies")

#Download 1981-2019 SI-x Leaf Anomalies, using a loop - will only get 2019 after it is addded as PRISM
for(year in 1981:2019){
  npn_download_geospatial('si-x:leaf_anomaly_prism', paste0(year,'-01-01'),output_path=paste0(year,"si-x_leaf_anomaly_prism",".tif"))
}

#Call rasters from file names and set NA values with a stack for 1981-2018.
files <- list.files(getwd(),pattern="*m.tif") 
SIXA_PRISM_stack <- stack(files) 
NAvalue(SIXA_PRISM_stack) <- -9999
SIXA_PRISM_stack
plot(SIXA_PRISM_stack[[34:38]])

#Call the 2019 rasters, set NA, resample to match the PRISM stack and plot to check.
SIXA19 <- raster("2019si-x_leaf_anomaly_ncep.tif")
NAvalue(SIXA19) <- -9999
SIXA19_4k <-resample(SIXA19, SIXA_PRISM_stack, method='bilinear') 
plot(SIXA19_4k)

#Add resampled 2019 raster to the PRISM stack
SIXA_stack <- stack(SIXA_PRISM_stack, SIXA19_4k)
SIXA_stack
plot(SIXA_stack[[34:39]])

#Download and call the 2020 Raster, set null values and resample to match the PRISM stack.
SIXA20 <- npn_download_geospatial("si-x:leaf_anomaly","2020-05-29") 
NAvalue(SIXA20) <- -9999
SIXA20_4k <-resample(SIXA20, SIXA_stack, method='bilinear') 
plot(SIXA20_4k)

#Create an "On-time" current year raster where all on-time pixels are = to 1.
f <- function(r1)  ifelse(r1 == 0, 1, 0)
SIXA20_4k_OnTime<- overlay(SIXA20_4k, fun=f)
plot(SIXA20_4k_OnTime)

#Output the OnTime Raster for use in QGIS.
setwd("~/Documents/My Files/USA-NPN/Data/Analysis/R_default/SIXV/OutputRasters/CurrentY_DynRI/Leaf/")
writeRaster(SIXA20_4k_OnTime, "2020_Anom_OnTime_leaf.tiff", format="GTiff",  overwrite=TRUE, NAflag=-9999) 

#Create an "Early" current year raster where all late or on-time pixels are null.
f <- function(r1)  ifelse(r1 <= -0.0000001, r1,  NA)
SIXA20_4k_Early<- overlay(SIXA20_4k, fun=f)
plot(SIXA20_4k_Early)

#Create a "Late" current year raster where all early or on-time pixels are null.
f <- function(r1)  ifelse(r1 >= 0.00000001, r1,  NA)
SIXA20_4k_Late<- overlay(SIXA20_4k, fun=f)
plot(SIXA20_4k_Late)

#Early Return Interval, Step 1: create overlays where 1 = spring in X year was as early or earlier than current year, otherwise 0.
f <- function(r1, r2)  ifelse(r1 <= r2, 1,  0)
SIXA_stack_Earlier<- overlay(SIXA_stack, SIXA20_4k_Early, fun=f)

#Plot example earlier than current year map to check.
plot(SIXA_stack_Earlier[[37]],
     main="Where X Year As Early or Earlier than 2020")

#Early RI Step 2: Count how many time each pixel was earlier than current year over the period.
SIXA_Earlier_count <-sum(SIXA_stack_Earlier)
plot(SIXA_Earlier_count)

#Early RI - Step 3, divide count raster by 38 to create Return Interval raster.
f <- function(r1)  ifelse(r1 == 0, r1,  38/r1)
RI_Early<- overlay(SIXA_Earlier_count, fun=f)
plot(RI_Early)

#Output the raster of the Return interval 
writeRaster(RI_Early, "2020_RI_Early_Leaf.tiff", format="GTiff", overwrite=TRUE, NAflag=-9999)

#Late Return Interval, Step 1: create overlays where 1 = spring in X year was as late or later than current year, otherwise 0.
f <- function(r1, r2)  ifelse(r1 >= r2, 1,  0)
SIXA_stack_Later<- overlay(SIXA_stack, SIXA20_4k_Late, fun=f)

#Plot example earlier than current year map to check.
plot(SIXA_stack_Later[[35]],
     main="Where X Year As Late or Later than 2020")

#Late RI Step 2: Count how many time each pixel was later than current year over the period.
SIXA_Later_count <-sum(SIXA_stack_Later)
plot(SIXA_Later_count)

#Late RI - Step 3, divide count raster by 38 to create Return Interval raster.
f <- function(r1)  ifelse(r1 == 0, r1,  38/r1)
RI_Late<- overlay(SIXA_Later_count, fun=f)
plot(RI_Late)

#Output the raster of the Return interval for use in QGIS
writeRaster(RI_Late, "2020_Anom_Late_leaf.tiff", format="GTiff",  overwrite=TRUE, NAflag=-9999) 
