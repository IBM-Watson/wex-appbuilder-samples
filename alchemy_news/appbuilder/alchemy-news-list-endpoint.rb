news_url = "https://gateway-a.watsonplatform.net/calls/data/GetNews"

news_params = {
  :apikey => 'YOUR_API_KEY_HERE',
  :outputMode => 'json',
  :maxResults => params[:max] || 5
}


returns = [
  "enriched.url.title",
  "enriched.url.url",
  "enriched.url.author",
  "enriched.url.publicationDate",
  "enriched.url.entities",
  "enriched.url.docSentiment",
  "enriched.url.concepts",
  "enriched.url.taxonomy"
]

news_params[:return] = returns.join(",")


lables = [
  "schema.original.url",
  "schema.enriched.docSentiment",
  "schema.enriched.concepts",
  "schema.enriched.keywords",
  "schema.enriched.entities"
]

news_params[:label_format_string] = lables.join(",")


news_params[:start] = params[:start] || "now"
news_params[:end] = params[:end] || "now-7d"

if params[:sentiment] == "positive" || params[:sentiment] == "negative"
   news_params["q.enriched.url.docSentiment.type"] = params[:sentiment]
end


news_params["q.enriched.url"] = params[:query]

# See the full list of searchable fields: http://docs.alchemyapi.com/docs/full-list-of-supported-news-api-fields

response = HttpClient.request(news_url, query: news_params)

# Returns the Alchemy News API response, parsed as a Ruby Object.  Good for debugging.
# JSON.parse(response.body, symbolize_names: true)

response.body
