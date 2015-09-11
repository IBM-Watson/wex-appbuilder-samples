endpoint_url = "http://wex-pi-helpers.mybluemix.net/pi/model_text/"

raise "Missing required parameter: text" unless params[:text]

body = { :text => params[:text] }
headers = { "Content-Type" => "application/json" }

response = HttpClient.request(endpoint_url, :body => body.to_json, :method => :post, :headers => headers)

response.body