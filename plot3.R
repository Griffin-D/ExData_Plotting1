# load libraries
        packages <- c("data.table", "lubridate")
        sapply(packages, require, character.only=TRUE, quietly=TRUE)

# Check for the directory, create it if it does not exist
        setwd("~/")
        if (!file.exists("data")) {
                dir.create("data")
        }

# change working directory to new folder
        setwd("~/data") 


# Get the dataset
        setInternet2(TRUE)
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
        fullDataSet <- unz(temp, 'household_power_consumption.txt')
        
# read 2 day subset from fullDataSet
        colVariables <- c(rep('character',2),rep('numeric',7))
        powerConsumption <- read.table(fullDataSet, header=TRUE,
                                       sep=';', na.strings='?', colClasses = colVariables)
        powerConsumption <- powerConsumption[powerConsumption$Date=='1/2/2007' | powerConsumption$Date=='2/2/2007',]
        
# close the connection
        unlink(temp)
        
# clean data
        columns <- c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
                     'SubMetering1','SubMetering2','SubMetering3')
        colnames(powerConsumption) <- columns
        powerConsumption$DateTime<-dmy(powerConsumption$Date)+hms(powerConsumption$Time)
        powerConsumption<-powerConsumption[,c(10,3:9)]

# create the directory and file
        if (!file.exists("plot 3")) {
                dir.create("plot 3")
        }

        png(filename='plot 3/plot3.png',width=480,height=480,units='px')


        lncol<-c('black','red','blue')
        lbls<-c('Sub_metering_1','Sub_metering_2','Sub_metering_3')
        plot(powerConsumption$DateTime,powerConsumption$SubMetering1,type='l',col=lncol[1],xlab='',ylab='Energy sub metering')
        lines(powerConsumption$DateTime,powerConsumption$SubMetering2,col=lncol[2])
        lines(powerConsumption$DateTime,powerConsumption$SubMetering3,col=lncol[3])

        legend('topright',legend=lbls,col=lncol,lty='solid')

# Close device
        x<-dev.off()