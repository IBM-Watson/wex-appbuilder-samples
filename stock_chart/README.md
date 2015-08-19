# Simple Stock Price Chart #

# Description and Use #

This ![widget](widget.erb) uses an ![endpoint](endpoint.erb) to fetch
and process stock data.  This data is then graphed using HighCharts,
showing a simple one-value plot over time.

[Screen Shot](screenshot.png)

This widget uses the ![Quandl](https://www.quandl.com/) API to provide
asset prices.  This API allows for free access for low-frequency
queries, however these have strict
![limits](http://help.quandl.com/article/68-is-there-a-rate-limit-or-speed-limit-for-api-usage).

The ![endpoint](endpoint.erb) must be named "StockChart". This
endpoint uses two parameters, `symbol` and `months`.  The `symbol`
parameter is used to pass in the exchange and stock symbols. The
`months` parameter is the number of past months to fetch.



