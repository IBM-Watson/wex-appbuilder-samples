# Simple Stock Price Chart #

# Description and Use #

This ![widget](widget.erb) uses an ![endpoint](endpoint.erb) to fetch
and process stock data.  This data is then graphed using HighCharts,
showing a simple one-value plot over time.

[Screen Shot](screenshot.png)

This widget uses the ![Quandl](https://www.quandl.com/) api to provide
asset prices.  This api allows for free access for low-frequency
queries, however these have strict
![limits](http://help.quandl.com/article/68-is-there-a-rate-limit-or-speed-limit-for-api-usage).

The ![endpoint](endpoint.erb) must be named "StockChart" and must take two
parameters, `symbol` and `months`.  These control the stock symbol the data is for and a number
past months to fetch.

[Parameters Needed](endpoint_params.png)

