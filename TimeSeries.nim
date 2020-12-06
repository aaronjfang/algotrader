import times
import parsecsv
import strutils
#declare TimeSeries struct -- this will be used to store data exported from AlphaVantage into something easy to work with
type
    TimeSeriesEntry* = tuple
        time:DateTime
        open:float
        `high`:float
        `low`:float
        close:float
        volume:int
    TimeSeries* = object
        data:seq[TimeSeriesEntry]

proc string2DateTime(text: string): DateTime
proc csvRow2TimeSeriesEntry(csvRow: CsvRow): TimeSeriesEntry
proc newTimeSeries*(csvParser: CsvParser): TimeSeries =
    var 
        data:seq[TimeSeriesEntry]
        temp = csvParser
    temp.readHeaderRow
    while temp.readRow():
        data.add(csvRow2TimeSeriesEntry(temp.row))
    result = TimeSeries(data: data)

proc csvRow2TimeSeriesEntry(csvRow: CsvRow): TimeSeriesEntry = 
    var 
        entry: TimeSeriesEntry
        splitstr: seq[string]
    splitstr = csvRow[0].split(',')
    entry = (string2DateTime(splitstr[0]), parseFloat(splitstr[1]), parseFloat(splitstr[2]), 
    parseFloat(splitstr[3]), parseFloat(splitstr[4]), parseInt(splitstr[5]))
    echo entry
    result = entry

#let's assume best intentions and hope that the incoming file is actually a CSV
#[
proc newTimeSeries*(csvFile:File): TimeSeries =
    result = new TimeSeries
]#

#need to fix time stuff
proc EST(): Timezone = 
    proc zonedTimeFromTime(time: Time): ZonedTime =
        result.isDst = false
        result.utcOffset = -5 
        result.time = time - 5.hours
    proc zonedTimeFromAdjTime(adjTime: Time): ZonedTime =
        result.isDst = false
        result.utcOffset = -5 
        result.time = adjTime + -5.hours
    result = newTimezone("EST", zonedTimeFromTime, zonedTimeFromAdjTime)

proc string2DateTime(text: string): DateTime =
    result = parse(text, "yyyy-MM-dd hh:mm:ss", EST())

echo string2DateTime("2020-11-06 18:45:00").local