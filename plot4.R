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
subdat$Global_active_power <- as.numeric(subdat$Global_active_power)
subdat$Global_reactive_power <- as.numeric(subdat$Global_reactive_power)
subdat$Voltage <- as.numeric(subdat$Voltage)
subdat$Sub_metering_1 <- as.numeric(subdat$Sub_metering_1)
subdat$Sub_metering_2 <- as.numeric(subdat$Sub_metering_2)
subdat$Sub_metering_3 <- as.numeric(subdat$Sub_metering_3)

#a vector combining the values of the first two columns, in correct format
full <- as.POSIXlt(strptime(paste(subdat$Date, subdat$Time), format="%Y-%m-%d %H:%M:%S"))

Sys.setlocale("LC_TIME", "English") 
par(mfrow = c(2,2), cex = 0.6)
plot(full, subdat$Global_active_power, type="l", ylab="Global Active Power", xlab="")
plot(full, subdat$Voltage, type="l", ylab="Voltage", xlab="datetime")
plot(full, subdat$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
points(full, subdat$Sub_metering_2, type="l", col="red")
points(full, subdat$Sub_metering_3, type="l", col="blue")
## ridiculoulsy high value for text.width. But that was the only way I could
## get the whole text of the legend within the box in the png file
## commented line is for the windows() output, no need for adjusting there
legend("topright", lty= c(1,1,1), text.width= 83000, bty = "n" ,col=c("black","red","blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#legend("topright", lty= c(1,1,1), col=c("black","red","blue"), box.lwd = 0,legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(full, subdat$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
dev.copy(png, file="plot4.png")
dev.off()