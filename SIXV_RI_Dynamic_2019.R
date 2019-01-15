library(raster)
library(sp)
library(rgdal)
rm(list=ls())
setwd("~/Documents/My Files/USA-NPN/Data/Analysis/R_default/SIXV/FLI_Anomalies")
SIXA81 <- raster("si-x_leaf_anomaly_prism1981.tif ")
SIXA82 <- raster("si-x_leaf_anomaly_prism1982.tif ")
SIXA83 <- raster("si-x_leaf_anomaly_prism1983.tif ")
SIXA84 <- raster("si-x_leaf_anomaly_prism1984.tif ")
SIXA85 <- raster("si-x_leaf_anomaly_prism1985.tif ")
SIXA86 <- raster("si-x_leaf_anomaly_prism1986.tif ")
SIXA87 <- raster("si-x_leaf_anomaly_prism1987.tif ")
SIXA88 <- raster("si-x_leaf_anomaly_prism1988.tif ")
SIXA89 <- raster("si-x_leaf_anomaly_prism1989.tif ")
SIXA90 <- raster("si-x_leaf_anomaly_prism1990.tif ")
SIXA91 <- raster("si-x_leaf_anomaly_prism1991.tif ")
SIXA92 <- raster("si-x_leaf_anomaly_prism1992.tif ")
SIXA93 <- raster("si-x_leaf_anomaly_prism1993.tif ")
SIXA94 <- raster("si-x_leaf_anomaly_prism1994.tif ")
SIXA95 <- raster("si-x_leaf_anomaly_prism1995.tif ")
SIXA96 <- raster("si-x_leaf_anomaly_prism1996.tif ")
SIXA97 <- raster("si-x_leaf_anomaly_prism1997.tif ")
SIXA98 <- raster("si-x_leaf_anomaly_prism1998.tif ")
SIXA99 <- raster("si-x_leaf_anomaly_prism1999.tif ")
SIXA00 <- raster("si-x_leaf_anomaly_prism2000.tif ")
SIXA01 <- raster("si-x_leaf_anomaly_prism2001.tif ")
SIXA02 <- raster("si-x_leaf_anomaly_prism2002.tif ")
SIXA03 <- raster("si-x_leaf_anomaly_prism2003.tif ")
SIXA04 <- raster("si-x_leaf_anomaly_prism2004.tif ")
SIXA05 <- raster("si-x_leaf_anomaly_prism2005.tif ")
SIXA06 <- raster("si-x_leaf_anomaly_prism2006.tif ")
SIXA07 <- raster("si-x_leaf_anomaly_prism2007.tif ")
SIXA08 <- raster("si-x_leaf_anomaly_prism2008.tif ")
SIXA09 <- raster("si-x_leaf_anomaly_prism2009.tif ")
SIXA10 <- raster("si-x_leaf_anomaly_prism2010.tif ")
SIXA11 <- raster("si-x_leaf_anomaly_prism2011.tif ")
SIXA12 <- raster("si-x_leaf_anomaly_prism2012.tif ")
SIXA13 <- raster("si-x_leaf_anomaly_prism2013.tif ")
SIXA14 <- raster("si-x_leaf_anomaly_prism2014.tif ")
SIXA15 <- raster("si-x_leaf_anomaly_prism2015.tif ")
SIXA16 <- raster("si-x_leaf_anomaly_prism2016.tif ")
SIXA17 <- raster("si-x_leaf_anomaly_prism2017.tif ")
SIXA18 <- raster("si-x_leaf_anomaly_ncep2018.tif")
SIXA19 <- raster("si-x_leaf_anomaly_ncep2019.tif")

NAvalue(SIXA81) <- -9999
NAvalue(SIXA82) <- -9999
NAvalue(SIXA83) <- -9999
NAvalue(SIXA84) <- -9999
NAvalue(SIXA85) <- -9999
NAvalue(SIXA86) <- -9999
NAvalue(SIXA87) <- -9999
NAvalue(SIXA88) <- -9999
NAvalue(SIXA89) <- -9999
NAvalue(SIXA90) <- -9999
NAvalue(SIXA91) <- -9999
NAvalue(SIXA92) <- -9999
NAvalue(SIXA93) <- -9999
NAvalue(SIXA94) <- -9999
NAvalue(SIXA95) <- -9999
NAvalue(SIXA96) <- -9999
NAvalue(SIXA97) <- -9999
NAvalue(SIXA98) <- -9999
NAvalue(SIXA99) <- -9999
NAvalue(SIXA00) <- -9999
NAvalue(SIXA01) <- -9999
NAvalue(SIXA02) <- -9999
NAvalue(SIXA03) <- -9999
NAvalue(SIXA04) <- -9999
NAvalue(SIXA05) <- -9999
NAvalue(SIXA06) <- -9999
NAvalue(SIXA07) <- -9999
NAvalue(SIXA08) <- -9999
NAvalue(SIXA09) <- -9999
NAvalue(SIXA10) <- -9999
NAvalue(SIXA11) <- -9999
NAvalue(SIXA12) <- -9999
NAvalue(SIXA13) <- -9999
NAvalue(SIXA14) <- -9999
NAvalue(SIXA15) <- -9999
NAvalue(SIXA16) <- -9999
NAvalue(SIXA17) <- -9999
NAvalue(SIXA18) <- -9999
NAvalue(SIXA19) <- -9999

#Resample the 2018 and 19 anomaly maps to match the prior years.
SIXA18_4k <- resample(SIXA18, SIXA17, method='bilinear') 
SIXA19_4k <-resample(SIXA19, SIXA17, method='bilinear') 

#Create an "Early" 2019 raster where all late or on-time pixels are null.
f <- function(r1)  ifelse(r1 <= -1, r1,  NA)
SIXA19_4k_Early<- overlay(SIXA19_4k, fun=f)

#See if that looks right.
plot(SIXA19_4k_Early)

#Create a "Late" 2019 raster where all early or on-time pixels are null.
f <- function(r1)  ifelse(r1 >= 1, r1,  NA)
SIXA19_4k_Late<- overlay(SIXA19_4k, fun=f)

#See if that looks right.
plot(SIXA19_4k_Late)

#Early Return Interval, step 1: create overlays where 1 = spring in X year was as early or earlier than 2018, otherwise 0.
f <- function(r1, r2)  ifelse(r1 <= r2, 1,  0)
SIXA81Earlier<- overlay(SIXA81, SIXA19_4k_Early, fun=f)
SIXA82Earlier<- overlay(SIXA82, SIXA19_4k_Early, fun=f)
SIXA83Earlier<- overlay(SIXA83, SIXA19_4k_Early, fun=f)
SIXA84Earlier<- overlay(SIXA84, SIXA19_4k_Early, fun=f)
SIXA85Earlier<- overlay(SIXA85, SIXA19_4k_Early, fun=f)
SIXA86Earlier<- overlay(SIXA86, SIXA19_4k_Early, fun=f)
SIXA87Earlier<- overlay(SIXA87, SIXA19_4k_Early, fun=f)
SIXA88Earlier<- overlay(SIXA88, SIXA19_4k_Early, fun=f)
SIXA89Earlier<- overlay(SIXA89, SIXA19_4k_Early, fun=f)
SIXA90Earlier<- overlay(SIXA90, SIXA19_4k_Early, fun=f)
SIXA91Earlier<- overlay(SIXA91, SIXA19_4k_Early, fun=f)
SIXA92Earlier<- overlay(SIXA92, SIXA19_4k_Early, fun=f)
SIXA93Earlier<- overlay(SIXA93, SIXA19_4k_Early, fun=f)
SIXA94Earlier<- overlay(SIXA94, SIXA19_4k_Early, fun=f)
SIXA95Earlier<- overlay(SIXA95, SIXA19_4k_Early, fun=f)
SIXA96Earlier<- overlay(SIXA96, SIXA19_4k_Early, fun=f)
SIXA97Earlier<- overlay(SIXA97, SIXA19_4k_Early, fun=f)
SIXA98Earlier<- overlay(SIXA98, SIXA19_4k_Early, fun=f)
SIXA99Earlier<- overlay(SIXA99, SIXA19_4k_Early, fun=f)
SIXA00Earlier<- overlay(SIXA00, SIXA19_4k_Early, fun=f)
SIXA01Earlier<- overlay(SIXA01, SIXA19_4k_Early, fun=f)
SIXA02Earlier<- overlay(SIXA02, SIXA19_4k_Early, fun=f)
SIXA03Earlier<- overlay(SIXA03, SIXA19_4k_Early, fun=f)
SIXA04Earlier<- overlay(SIXA04, SIXA19_4k_Early, fun=f)
SIXA05Earlier<- overlay(SIXA05, SIXA19_4k_Early, fun=f)
SIXA06Earlier<- overlay(SIXA06, SIXA19_4k_Early, fun=f)
SIXA07Earlier<- overlay(SIXA07, SIXA19_4k_Early, fun=f)
SIXA08Earlier<- overlay(SIXA08, SIXA19_4k_Early, fun=f)
SIXA09Earlier<- overlay(SIXA09, SIXA19_4k_Early, fun=f)
SIXA10Earlier<- overlay(SIXA10, SIXA19_4k_Early, fun=f)
SIXA11Earlier<- overlay(SIXA11, SIXA19_4k_Early, fun=f)
SIXA12Earlier<- overlay(SIXA12, SIXA19_4k_Early, fun=f)
SIXA13Earlier<- overlay(SIXA13, SIXA19_4k_Early, fun=f)
SIXA14Earlier<- overlay(SIXA14, SIXA19_4k_Early, fun=f)
SIXA15Earlier<- overlay(SIXA15, SIXA19_4k_Early, fun=f)
SIXA16Earlier<- overlay(SIXA16, SIXA19_4k_Early, fun=f)
SIXA17Earlier<- overlay(SIXA17, SIXA19_4k_Early, fun=f)
SIXA18Earlier<- overlay(SIXA18_4k, SIXA19_4k_Early, fun=f)

#Plot example earlier than 2019 map to check.
plot(SIXA85Earlier,
  main="Where X Year As Early or Earlier than 2019")

#Early Return Interval, step 2: Calculate return interval by dividng the number of years by the sum of "as-early/earlier than" 2019 maps.
SIXA_2019_RI_Early<- overlay(SIXA81Earlier,
                      SIXA82Earlier,
                      SIXA83Earlier,
                      SIXA84Earlier,
                      SIXA85Earlier,
                      SIXA86Earlier,
                      SIXA87Earlier,
                      SIXA88Earlier,
                      SIXA89Earlier,
                      SIXA90Earlier,
                      SIXA91Earlier,
                      SIXA92Earlier,
                      SIXA93Earlier,
                      SIXA94Earlier,
                      SIXA95Earlier,
                      SIXA96Earlier,
                      SIXA97Earlier,
                      SIXA98Earlier,
                      SIXA99Earlier,
                      SIXA00Earlier,
                      SIXA01Earlier,
                      SIXA02Earlier,
                      SIXA03Earlier,
                      SIXA04Earlier,
                      SIXA05Earlier,
                      SIXA06Earlier,
                      SIXA07Earlier,
                      SIXA08Earlier,
                      SIXA09Earlier,
                      SIXA10Earlier,
                      SIXA11Earlier,
                      SIXA12Earlier,
                      SIXA13Earlier,
                      SIXA14Earlier,
                      SIXA15Earlier,
                      SIXA16Earlier,
                      SIXA17Earlier,
                      SIXA18Earlier,
                      fun=function(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31, r32, r33, r34, r35, r36, r37, r38){return(38/(r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15+r16+r17+r18+r19+r20+r21+r22+r23+r24+r25+r26+r27+r28+r29+r30+r31+r32+r33+r34+r35+r36+r37+r38))})
  
#Plot return interval map.
plot(SIXA_2019_RI_Early,
  main="Return Interval for Early Spring, 2019, over 1981-2018 period")
                        
#Output the raster of the Return interval (note that this lands in your working directory unless you specify something else)
writeRaster(SIXA_2019_RI_Early, "2019_RI.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE, # CAUTION: if this is true, it will overwrite an
                            # existing file
            NAflag=-9999) # set no data value to -9999
 
#Now, for Late Return Interval, step 1: Create overlays where 1 = spring in X year was as LATE or LATER than 2019, otherwise 0.
f <- function(r1, r2)  ifelse(r1 <= r2, 1,  0)
SIXA81Later<- overlay(SIXA81, SIXA19_4k_Late, fun=f)
SIXA82Later<- overlay(SIXA82, SIXA19_4k_Late, fun=f)
SIXA83Later<- overlay(SIXA83, SIXA19_4k_Late, fun=f)
SIXA84Later<- overlay(SIXA84, SIXA19_4k_Late, fun=f)
SIXA85Later<- overlay(SIXA85, SIXA19_4k_Late, fun=f)
SIXA86Later<- overlay(SIXA86, SIXA19_4k_Late, fun=f)
SIXA87Later<- overlay(SIXA87, SIXA19_4k_Late, fun=f)
SIXA88Later<- overlay(SIXA88, SIXA19_4k_Late, fun=f)
SIXA89Later<- overlay(SIXA89, SIXA19_4k_Late, fun=f)
SIXA90Later<- overlay(SIXA90, SIXA19_4k_Late, fun=f)
SIXA91Later<- overlay(SIXA91, SIXA19_4k_Late, fun=f)
SIXA92Later<- overlay(SIXA92, SIXA19_4k_Late, fun=f)
SIXA93Later<- overlay(SIXA93, SIXA19_4k_Late, fun=f)
SIXA94Later<- overlay(SIXA94, SIXA19_4k_Late, fun=f)
SIXA95Later<- overlay(SIXA95, SIXA19_4k_Late, fun=f)
SIXA96Later<- overlay(SIXA96, SIXA19_4k_Late, fun=f)
SIXA97Later<- overlay(SIXA97, SIXA19_4k_Late, fun=f)
SIXA98Later<- overlay(SIXA98, SIXA19_4k_Late, fun=f)
SIXA99Later<- overlay(SIXA99, SIXA19_4k_Late, fun=f)
SIXA00Later<- overlay(SIXA00, SIXA19_4k_Late, fun=f)
SIXA01Later<- overlay(SIXA01, SIXA19_4k_Late, fun=f)
SIXA02Later<- overlay(SIXA02, SIXA19_4k_Late, fun=f)
SIXA03Later<- overlay(SIXA03, SIXA19_4k_Late, fun=f)
SIXA04Later<- overlay(SIXA04, SIXA19_4k_Late, fun=f)
SIXA05Later<- overlay(SIXA05, SIXA19_4k_Late, fun=f)
SIXA06Later<- overlay(SIXA06, SIXA19_4k_Late, fun=f)
SIXA07Later<- overlay(SIXA07, SIXA19_4k_Late, fun=f)
SIXA08Later<- overlay(SIXA08, SIXA19_4k_Late, fun=f)
SIXA09Later<- overlay(SIXA09, SIXA19_4k_Late, fun=f)
SIXA10Later<- overlay(SIXA10, SIXA19_4k_Late, fun=f)
SIXA11Later<- overlay(SIXA11, SIXA19_4k_Late, fun=f)
SIXA12Later<- overlay(SIXA12, SIXA19_4k_Late, fun=f)
SIXA13Later<- overlay(SIXA13, SIXA19_4k_Late, fun=f)
SIXA14Later<- overlay(SIXA14, SIXA19_4k_Late, fun=f)
SIXA15Later<- overlay(SIXA15, SIXA19_4k_Late, fun=f)
SIXA16Later<- overlay(SIXA16, SIXA19_4k_Late, fun=f)
SIXA17Later<- overlay(SIXA17, SIXA19_4k_Late, fun=f)
SIXA18Later<- overlay(SIXA18_4k, SIXA19_4k_Late, fun=f)

#Plot example later than 2019 map to check.
plot(SIXA05Later,
     main="Where X Year As Late or Later than 2019")

#Late Return Interval, step 2: Calculate return interval by dividng the number of years by the sum of the later than 2019 maps.
SIXA_2019_RI_Late<- overlay(SIXA81Later,
                             SIXA82Later,
                             SIXA83Later,
                             SIXA84Later,
                             SIXA85Later,
                             SIXA86Later,
                             SIXA87Later,
                             SIXA88Later,
                             SIXA89Later,
                             SIXA90Later,
                             SIXA91Later,
                             SIXA92Later,
                             SIXA93Later,
                             SIXA94Later,
                             SIXA95Later,
                             SIXA96Later,
                             SIXA97Later,
                             SIXA98Later,
                             SIXA99Later,
                             SIXA00Later,
                             SIXA01Later,
                             SIXA02Later,
                             SIXA03Later,
                             SIXA04Later,
                             SIXA05Later,
                             SIXA06Later,
                             SIXA07Later,
                             SIXA08Later,
                             SIXA09Later,
                             SIXA10Later,
                             SIXA11Later,
                             SIXA12Later,
                             SIXA13Later,
                             SIXA14Later,
                             SIXA15Later,
                             SIXA16Later,
                             SIXA17Later,
                             SIXA18Later,
                             fun=function(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31, r32, r33, r34, r35, r36, r37, r38){return(38/(r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15+r16+r17+r18+r19+r20+r21+r22+r23+r24+r25+r26+r27+r28+r29+r30+r31+r32+r33+r34+r35+r36+r37+r38))})

#Plot return interval map.
plot(SIXA_2019_RI_Late,
     main="Dynamic Return Interval for Late Spring, 2019, over 1981-2018 period")

#Output the raster of the Return interval
writeRaster(SIXA_2019_RI_Late, "2018_RI_Late.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE, # CAUTION: if this is true, it will overwrite an
            # existing file
            NAflag=-9999) # set no data value to -9999           