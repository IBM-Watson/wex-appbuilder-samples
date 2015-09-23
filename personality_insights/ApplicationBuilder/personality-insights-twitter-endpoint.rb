endpoint_url = "http://YOUR_ENDPOINT_HERE.mybluemix.net/pi/model_tweets/"

raise "Missing required parameter: handle" unless params[:handle]

headers = { "Content-Type" => "application/json" }

response = HttpClient.request(endpoint_url + params[:handle], :headers => headers)

response.body