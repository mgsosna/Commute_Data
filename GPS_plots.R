############################################################################################
# Plot trajectory data from the GPS Logger for Android app. 
# (https://play.google.com/store/apps/details?id=com.mendhak.gpslogger&hl=en)
#
# Matt Grobis | Nov 2017
############################################################################################
# Before we get started, you'll need to download the GPS data from your phone onto your 
# computer. I've saved the files (which are .CSVs) into a folder called "GPS data" on my
# Desktop.

  setwd("C:/Users/mmgro_000/Desktop/GPS data")
  
  # 1. Exclude accidents (turning on GPS on accident)
  files <- list.files(pattern = ".csv")
  
  rows <- c()
  for(i in 1:length(files)){
    rows[i] <- dim(read.csv(files[i]))[1]
    
  }
  
  hist(rows)  # Ok, so let's exclude anything below 50 seconds (4 events)

############################################################################
  # 2. Plot trajectories on the Google Maps image

  # Load the trajectories from all the files into one array
  # - Dimensions are N time points, Lat-Lon-Speed, N files
  trajectories <- array(NA, dim = c(max(rows), 3, length(files)))
  
  for(i in 1:length(files)){
    
    if(rows[i] > 50){
      
      data <- read.csv(files[i], header = T)
      
      trajectories[1:nrow(data), 1, i] <- data$lat
      trajectories[1:nrow(data), 2, i] <- data$lon
      trajectories[1:nrow(data), 3, i] <- data$speed
      
    }
    print(i)
  }   

#----------------------------------------------------------------------------
  library(ggmap)
  library(ggplot2)
  
  # Get the Google Maps GPS image  
  dc <- get_map(location = c(lat = mean(trajectories[, 1, ], na.rm = T),
                             lon = mean(trajectories[, 2, ], na.rm = T)), 
                zoom = 18) 
  
  # For ggplot, we need a data frame    
  lat <- as.vector(trajectories[, 1, ])
  lon <- as.vector(trajectories[, 2, ])
  sp <- as.vector(trajectories[, 3, ])
  
  # There are some NAs in the speed data, so need to remove those positions
  # from the latitude and longitude data, too.
  df <- data.frame("lat" = lat[!is.na(sp)], 
                   "lon" = lon[!is.na(sp)],
                   "sp" = sp[!is.na(sp)])
  
  # Set any speed values above 3 to 3
  df$sp[df$sp > 3] <- 3

#-------------------------------------------------------------------------------
  # The actual plots:
  
  # Simple plot
  ggmap(dc) + geom_point(data = df, aes(x = lon, y = lat), alpha = 0.3, 
                         col = "deepskyblue4")
  
  
  # Binned and colored by speed
  ggmap(dc) + 
    stat_summary_2d(data = df, aes(x = lon, y = lat, z = sp), bins = 180) +
    scale_fill_gradient(low = "black", high = "green", 
                        guide = guide_legend(title = "Speed (m/s)"))


################################################################################
  # 3a. Get data on commute durations and speeds
  library(stringr)
  
  times <- speeds <- c()
  
  for(i in 1:length(files)){
    
    if(rows[i] > 50)
      
      data <- read.csv(files[i], header = T)
    
    # Commute times
    com.start <- strptime(substr(data$time[1], 12, 19), 
                          format = "%H:%M:%S")
    com.end <- strptime(substr(data$time[nrow(data)], 12, 19), 
                        format = "%H:%M:%S")
    
    times[i] <- difftime(com.end, com.start)
    
    # Speeds
    speeds[i, 1:length(data$speed)] <- data$speed
    
  }
  
  # Remove tracking error in speeds
  sp.vec <- as.vector(speeds)      
  sp.vec <- sp.vec[!is.na(sp.vec)]  # Remove NAs
  
  summary(sp.vec[sp.vec > 0])
  
  # The IQR for when I'm walking is [0.9825, 1.3810]. IQR = 0.3985
  # - I can therefore label outliers as 1.3810 + (3.0 * 0.3985) = 2.577 m/s
  # - Let's just say 3 m/s is the cutoff.

#-----------------------------------------------------------------------------
  # 3b. Plot it
  library(RColorBrewer)
  
  time.cols <- colorRampPalette(c(3, "orange", "red"))(n = 25)
  walk.cols <- colorRampPalette(c("black", "deepskyblue4", "white"))(n = 30)
  
  # Normalize the speed counts so you can plot the probabilities (doesn't work
  # for the time data for some reason)
  sp.hist <- hist(sp.vec[sp.vec < 3], plot = F, breaks = 30)
  sp.hist$counts <- sp.hist$counts / sum(sp.hist$counts)
  
  #---------------------
  par(mfrow = c(1,2)) ;   par(oma = c(0, 1, 0, 0))
  
  hist(times[times < 10], xlim = c(2.5, 5), col = time.cols, breaks = 20, 
       ylim = c (0, 10), font.axis = 2, font.lab = 2, xlab = "Time (min)", 
       las = 1, cex.axis = 1.2, main = "How long it took to walk to work", 
       cex.main = 1.7, cex.lab = 1.4)  
  
  plot(sp.hist, main = "My walking speed", xlab = "Commuting speed (m/s)", 
       font.lab = 2, ylim = c(0, 0.25), font.axis = 2, col = walk.cols, 
       las = 1, cex.lab = 1.5, xlim = c(0, 3), cex.main = 1.7, cex.axis = 1.2, 
       ylab = NA)
  mtext(outer = F, side = 2, font = 2, cex = 1.5, "Probability", padj = -4)

