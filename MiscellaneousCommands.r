## Loading a CSV file ###
#mydata = read.csv("filename.csv", head=TRUE, sep=",")

rownames(mydata) = c(mydata$Transaction.Name) #Assigning the row id's of the table to the transactions names.

##*******************##
#Create BarPlot
##*******************##

GraphData = rbind(mydata$ColName1[1:5],  mydata$ColName2[1:5]) 
mp = barplot(GraphData, main="Average Response Time (secs)", xlab="Transaction Name", ylab="Response Time (secs)", col=c("darkblue","red"), beside=TRUE)
text(seq(1,15, by=3), par("usr")[3]-0.44, srt = 45, adj = 0.5, cex=0.6, labels = mydata$Transaction.Name[1:5] , xpd = TRUE, font = 2)

##*******************##
#Create a GGPLOT
##*******************##

myPlotData = data.frame(myTrans = factor(mydata$Transaction.Name[1:5]), myRelease=c("ColName1", "ColName2"), myRespTimes=c(mydata$ColName1[1:5], mydata$ColName2[1:5]))  #Doesn't need reshaping. Skip to ggplot
ggplot(data=myPlotData, aes(x=myTrans, y=myRespTimes, fill=myRelease)) + geom_bar(stat="identity", position="dodge")+xlab("Transaction Name")+ylab("Response Time (secs)")+ggtitle("Average Response Times (secs)")+ theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))

myPlotData = mydata[1:5,] 
myPlotData = subset(myPlotData, select = c(1,4,6))
#myPlotData = subset(mydata[1:5,], select = c(1,4,6)) # Combining 2 commands above this line
myPlotData = mydata[1:5,c(1,4,6)] # The above can also be written this way
library(reshape2)
myPlotData = melt(myPlotData)
#myPlotData = melt(subset(mydata[1:5,], select = c(1,4,6)))  # Combining 3 commands above this line
myPlotData
library(ggplot2)
#ggplot(myPlotData) +geom_point(aes(x=myTrans))
ggplot(data=myPlotData, aes(x=Transaction.Name, y=value, fill=variable)) + geom_bar(stat="identity", position="dodge")+ xlab("Transaction Name")+ ylab("Response Time (secs)")+ ggtitle("Average Response Times (secs)")+ theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))


require(quantmod)
install.packages('tseries')

googleExists= url.exists("http://www.omegahat.org")

## For Portal Access Logs from SPLUNK

#For Working with Excel Files

mydata = read.csv("C:/SplunkAccessLogs.csv", head=TRUE, sep=",")
splunkData = subset(mydata, select=c(userID,EventDate,EventTime,HTTPCmd,url,HTTPVersion,HTTPStatus,Bytes,ResponseTime,Referrer,UserAgent,OrgID,host,sourcetype,source,patientUID,transactionId,Params)) 

#Set Option to Print the entire file
options(max.print=1000000)

#############################

#    Connecting to Excel ####

##############################
#require(stats)
require(XLConnect)
#Create a new workbook
myXLFile = loadWorkbook("C:/SplunkData.xlsx", create=TRUE)
#Create/Add worksheet
createSheet(myXLFile, name="SplunkData")
createSheet(myXLFile, name="SortedSplunkData")
# Setting the sheet tab color to red 
setSheetColor(myXLFile, "SplunkData", XLC$COLOR.RED)
setSheetColor(myXLFile, "SortedSplunkData", XLC$COLOR.GREEN) 
#Add data to worksheet
writeWorksheet(myXLFile, data=splunkData, sheet="SplunkData", header=TRUE)

#Sorting Data and add to the worksheet
attach(splunkData)
sort.splunkData = splunkData[order(userID, EventDate, EventTime),]
detach(splunkData)
writeWorksheet(myXLFile, data=sort.splunkData, sheet="SortedSplunkData", header=TRUE)
 
#Save the workbook
saveWorkbook(myXLFile)

sort.splunkData[1:10,1:3]



#############################

### Connecting to Oracle ####

##############################
#Sys.setenv(JAVA_HOME='C:/Program Files/Java/1.6.0_45')
Sys.setenv(JAVA_HOME="")
#options(java.parameters="-Xmx2g")
library(rJava)
#.jinit()
#print(.jcall("java/lang/System", "S", "getProperty", "java.version"))
library(RJDBC)
# Create connection driver and open connection
jdbcDriver = JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Softwares/RDrivers/ojdbc6.jar")
jdbcConnection = dbConnect(jdbcDriver,"jdbcURL","uname","passwd")

# Query on the Oracle instance name.
instanceName = dbGetQuery(jdbcConnection,"SELECT instance_name FROM v$instance")
print(instanceName)

tableList = dbGetQuery(jdbcConnection, "select owner, table_name from all_tables")
dbListFields(jdbcConnection, "FieldName")

#Close connection
dbDisconnect(jdbcConnection)




