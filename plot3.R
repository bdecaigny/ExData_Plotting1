# quite bizar to import everything as character, I know. 
# But without it, I get values as high as 14 for Sub_metering_2
# casting as character first and then explicitly converting to numeric solves this
classes <- c("character","character","character","character","character","character","character","character","character")
data <- read.csv("./household_power_consumption.txt", header=TRUE, sep =";", colClasses = classes)

#subsetting the data
#probaly not the most elegant way, but it doe sthe trick
data$Date <- as.Date(strptime(data$Date, format="%d/%m/%Y"))
dates <- data$Date
first <- dates == as.Date("2007-02-01") 
second <- dates == as.Date("2007-02-02")
both <- first | second
subdat <- subset(data, both)

#see above: explict casting
subdat$Sub_metering_1 <- as.numeric(subdat$Sub_metering_1)
subdat$Sub_metering_2 <- as.numeric(subdat$Sub_metering_2)
subdat$Sub_metering_3 <- as.numeric(subdat$Sub_metering_3)

#a vector combining the values of the first two columns, in correct format
full <- as.POSIXlt(strptime(paste(subdat$Date, subdat$Time), format="%Y-%m-%d %H:%M:%S"))

#nobody want s Dutch subtitles, I guess :-)
Sys.setlocale("LC_TIME", "English") 

plot(full, subdat$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
points(full, subdat$Sub_metering_2, type="l", col="red")
points(full, subdat$Sub_metering_3, type="l", col="blue")
## ridiculoulsy high value for text.width. But that was the only way I could
## get the whole text of the legend within the box in the png file
## commented line is for the windows() output, no need for adjusting there
legend("topright", lty= c(1,1,1), text.width= 55000, col=c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# legend("topright", lty= c(1,1,1), col=c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file="plot3.png")
dev.off()