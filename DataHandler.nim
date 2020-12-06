import httpclient
import json
import parsecsv
import streams
import os
import strutils

#declare URL to be used and HTTP client instance
const url:string = "https://www.alphavantage.co/query?"
let client:HttpClient = newHttpClient()

#declare DataHandler struct
type
    DataHandler* = object
        apiKey:string

#define constructor (overloaded to string and file for API key)
proc newDataHandler*(yourApiKey:string): DataHandler =
    result = DataHandler(apiKey: yourApiKey)

proc newDataHandler*(apiKeyFile:File): DataHandler =
    result = DataHandler(apiKey: apiKeyFile.readLine)

#pulls data from AlphaVantage and saves it to [project root]/datadir/[ticker name]/
proc getHistoricDataFor*(a: DataHandler, ticker: string, interval: string, slice: string): string {.discardable}= 
    var
        query = url&"function=TIME_SERIES_INTRADAY_EXTENDED"&"&symbol="&ticker&"&interval="&interval&"&slice="&slice&"&adjusted=true&apikey="&a.apiKey
        content = client.getContent(query)
    let 
        tickerdir:string = os.getCurrentDir()&"/datadir/"&toLowerAscii(ticker)
        filedir:string = tickerdir&"/"&interval&slice&".csv"
    if os.dirExists(tickerdir):
        writeFile(filedir, content)
    else:
        os.createDir(tickerdir)
        writeFile(filedir, content)
    result = filedir

#take dir and load all data to memory (note: I don't really like returning a CsvParser due to its bulkiness... I will need to make a new type to store the time-series data)
proc loadHistoricDataFromDisk*(a:DataHandler, tickerdirectory:string): CsvParser =
    var parser: CsvParser
    for kind, path in walkDir(tickerdirectory):
        echo path
        var stream = newFileStream(path, fmRead)
        open(parser, stream)
    result = parser 

