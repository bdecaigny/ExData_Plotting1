# quite bizar to import everything as character, I know. 
# But without it, the period in Global_active_power
#is not interpreted correctly (mutliplying everything with 1000)
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

hist(subdat$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")

#copying to file
dev.copy(png, file="plot1.png")
dev.off()