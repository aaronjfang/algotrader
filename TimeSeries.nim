import times
#declare TimeSeries struct -- this will be used to store data exported from AlphaVantage into something easy to work with
type
    TimeSeries* = object
        size:int
        time:seq[DateTime]
        open:seq[float32]
        `high`:seq[float]
        `low`:seq[float]
        close:seq[float]
        volume:seq[int]


#[
proc newTimeSeries*(csvFile:File) =
    csvFile.getOsFileHandle()
]#
