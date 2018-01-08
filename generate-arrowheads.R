## set working directory (make sure to modify path)
setwd("~/Documents/GitHub/generate-arrowheads/")

## install and load packages
#install.packages("magick")
library(magick)

## check for png capabilities
stopifnot(magick::magick_config()$png)

## load original image
## and read original size parameters
arrowhead <- image_read("original.png")
width_original <- image_info(arrowhead)$width
height_original <- image_info(arrowhead)$height

## create output directory
output_dir <- format(Sys.time(), "%Y%m%d%H%M%S")
dir.create(output_dir)

for (angle in 0:359) {
  ## rotate image
  ## angles in Tableau start at 3 o'clock position and rotate CCW
  rotated <- image_rotate(image_background(arrowhead, 
                                          "blue"), 
                          -angle)
  ## read new size parameters and calculate offset
  height <- image_info(rotated)$height
  height_offset <- (height - height_original) / 2
  crop_string <- paste0(as.character(width_original), 
                        "x", 
                        as.character(height_original), 
                        "+0+", 
                        as.character(height_offset))
  rotated <- image_crop(rotated, 
                        crop_string)
  
  ## export rotated image
  image_write(rotated, 
              path = paste0(output_dir, 
                            "/arrowhead_", 
                            sprintf("%03d", angle), 
                            ".png"), 
              format = "png")
}
