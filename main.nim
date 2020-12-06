# commenting for posterity
# Data provided by IEX Cloud
import TimeSeries, DataHandler, os, parsecsv

#test this puppy out with TSLA 
var handler:DataHandler = newDataHandler(open("api_key.txt"))
handler.getHistoricDataFor("tsla", "15min", "year1month1")

#try to load a CSV
var csv = handler.loadHistoricDataFromDisk(os.getCurrentDir()&"/datadir/tsla/")

var testTimeSeries = newTimeSeries(csv)


