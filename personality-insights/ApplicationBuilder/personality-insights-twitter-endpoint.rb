endpoint_url = "http://wex-pi-helpers.mybluemix.net/pi/model_tweets/"

raise "Missing required parameter: handle" unless params[:handle]

headers = { "Content-Type" => "application/json" }

response = HttpClient.request(endpoint_url + params[:handle], :headers => headers)

response.body