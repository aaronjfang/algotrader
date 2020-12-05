# commenting for posterity
# Data provided by IEX Cloud
import httpclient


let
    api_key:string = open("api_key.txt").readLine
    site:string = "https://sandbox.iexapis.com/"
    version:string = "stable"


var 
    client = newHttpClient()
    content:string = site&version # in nim we can assign variable to concatenated values, as long as we don't change the value of the strings 

echo(content)

var 
    ticker:string = "TSLA"
    query:string = content&"/stock/"&ticker&"/quote?token="&api_key
echo query
