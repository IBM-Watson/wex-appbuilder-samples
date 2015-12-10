news_url = "https://gateway-a.watsonplatform.net/calls/data/GetNews"

news_params = {
  :apikey => 'YOUR_API_KEY_HERE',
  :outputMode => 'json'
}

# params = JSON.parse(params, symbolize_names: true)

news_params[:start] = params[:start] || "now"
news_params[:end] = params[:end] || "now-7d"
news_params[:timeslice] = params[:timeSlice] || "1d"

if params[:sentiment] == "positive" || params[:sentiment] == "negative"
   news_params["q.enriched.url.docSentiment.type"] = params[:sentiment]
end

news_params["q.enriched.url"] = params[:query]

# See the full list of searchable fields: http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields
# news_params["q.enriched.url.entities.entity"] = params[:query]

response = HttpClient.request(news_url, query: news_params)

# Returns the Alchemy News API response, parsed as a Ruby Object.  Good for debugging.
# JSON.parse(response.body, symbolize_names: true)

response.body
