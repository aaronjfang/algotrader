import httpclient
import json
import parsecsv
const url:string = "https://www.alphavantage.co/query?"
let client:HttpClient = newHttpClient()

type
    DataHandler* = object
        apiKey:string

proc newDataHandler*(yourApiKey:string): DataHandler =
    result = DataHandler(apiKey: yourApiKey)

proc newDataHandler*(apiKeyFile:File): DataHandler =
    result = DataHandler(apiKey: apiKeyFile.readLine)


proc getHistoricDataFor*(a: DataHandler, ticker: string, interval: string, slice: string) = 
    # make web query to AlphaVantage
    var
        query = url&"function=TIME_SERIES_INTRADAY_EXTENDED"&"&symbol="&ticker&"&interval="&interval&"&slice="&slice&"&adjusted=true&apikey="&a.apiKey
        content = client.getContent(query)
        parser: CsvParser
    echo query
    parser.open(content)
    #parser.readHeaderRow()
    #parse 
   
var 
    handler = newDataHandler(open("api_key.txt"))
    # data = handler.getHistoricalDataFor("TSLA", "15min", "year1month1")

handler.getHistoricDataFor("NOT_A_TICKER", "15min", "year1month1")