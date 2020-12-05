import httpclient
import json
import parsecsv
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
proc getHistoricDataFor*(a: DataHandler, ticker: string, interval: string, slice: string) = 
    var
        query = url&"function=TIME_SERIES_INTRADAY_EXTENDED"&"&symbol="&ticker&"&interval="&interval&"&slice="&slice&"&adjusted=true&apikey="&a.apiKey
        content = client.getContent(query)
    
    if os.dirExists(os.getCurrentDir()&"/datadir/"&toLowerAscii(ticker)):
        writeFile(os.getCurrentDir()&"/datadir/"&ticker&"/"&interval&slice&".csv", content)
    else:
        os.createDir(os.getCurrentDir()&"/datadir/"&toLowerAscii(ticker))
        writeFile(os.getCurrentDir()&"/datadir/"&ticker&"/"&interval&slice&".csv", content)

#test this puppy out with TSLA 
newDataHandler(open("api_key.txt")).getHistoricDataFor("tsla", "15min", "year1month1")