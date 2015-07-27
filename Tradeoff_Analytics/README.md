# Integrating the Watson Developer Cloud Tradeoff Analytics Service with Watson Explorer

[IBM Watson Explorer](http://www.ibm.com/smarterplanet/us/en/ibmwatson/explorer.html) combines search and content analytics with unique cognitive computing capabilities available through external cloud services such as [Watson Developer Cloud](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/) to help users find and understand the information they need to work more efficiently and make better, more confident decisions.

The [IBM Watson Tradeoff Analytics service](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/tradeoff-analytics/index.shtml) helps people make better choices when faced with multiple, often conflicting goals and alternatives. By using mathematical filtering techniques to identify the top options based on multiple criteria, the service can help decision makers explore the trade-offs between options when making complex decisions. The full Tradeoff Analytics reference is available on the [IBM Watson Tradeoff Analytics service website](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/tradeoff-analytics/index.shtml).

The goal of this tutorial is to demonstrate how to get started with an integration between Watson Explorer and the Watson Tradeoff Analytics service available on IBM Watson Developer Cloud. By the end of the tutorial you will have a Tradeoff Analytics Bluemix application and a Tradeoff Analytics widget for Watson Explorer that provides visualization and analytical recommendations about books using data indexed by Watson Explorer Engine.

<img src="appbuilder/tradeoff-analytics-widget-screenshot.png" alt="Screen shot of the "Tradeoff Analytic for Books" style="width: 300px;"/>

## Prerequisites
Please see the [Introduction](https://github.com/Watson-Explorer/wex-wdc-integration-samples) for an overview of the integration architecture, and the tools and libraries that need to be installed to create Java-based applications in Bluemix.

- An [IBM Bluemix](https://ace.ng.bluemix.net/) account
- [Watson Explorer](http://www.ibm.com/smarterplanet/us/en/ibmwatson/explorer.html) - Installed, configured, and running
- The Watson Explorer [AppBuilder tutorial](http://www.ibm.com/support/knowledgecenter/SS8NLW_10.0.0/com.ibm.swg.im.infosphere.dataexpl.appbuilder.doc/c_de-ab-devapp-tutorial.html) has been completed
- The [Application Builder proxy](https://github.com/Watson-Explorer/wex-wdc-integration-samples/tree/master/proxy) up and running.


## What's Included in this Tutorial

This tutorial will walk you through the creation of a Watson Explorer Application Builder Tradeoff Analytics for Books widget. This widget sends information about a set of books -- including the books' titles, the year of publication, the size, the 2010 price, and the 2011 price -- to the Application Builder proxy, which in turn sends the problem information to the Bluemix application, which in turn sends the problem information to the Tradeoff Analytics service, which responds with details of recommendation and solutions.

To support this new chain of communication, modifications are made to the Application Builder proxy. 

## Step-by-Step Tutorial

This section outlines the steps required to configure and deploy the Watson Explorer Application Builder Tradeoff Analytics for Books widget.

### Deploying the Tradeoff Analytics sample application in Bluemix

The Bluemix documentation can be found [here](https://www.ng.bluemix.net/docs/).

Deploy the Bluemix application that uses the Trade-off Analytics Service.

[![Deploy Trade-off Analytics to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/watson-developer-cloud/tradeoff-analytics-java) 

Once the application has finished restarting, it is ready.

### Modifications to the Application Builder proxy

A simple [proxy](https://github.com/Watson-Explorer/wex-wdc-integration-samples/tree/master/proxy) was developed to run on the Application Builder server to satisfy the same-origin policy of end-user web browsers when individual widgets need to contact other hosts (for example, in Bluemix) via Ajax.  

Make the following changes to the sample Proxy.

1. Navigate to the proxy installation directory.  This is typically under the Watson Explorer installation directory at `AppBuilder/wlp/usr/servers/AppBuilder/apps/proxy`.
2. Edit the `WEB-INF/config.ru` file.  Add the following line near the other similar lines, replacing `YOUR_BLUEMIX_HOST` with the host you chose above in your manifest.yml.
   
   `set :ta_endpoint, "http://YOUR_BLUEMIX_HOST.mybluemix.net/api/problem"`
3. Enter the `lib/proxy.rb` file and add the following code block
   ```
	post '/ta/' do
   		data = JSON.load(request.body)
	    headers = {
	         "Content-Type" => "application/json"
	    }
	    response = Excon.post(settings.taDemo_endpoint, :body => data.to_json, :headers => headers)
	    response.body
		end
   	```

### Creating a Watson Explorer Application Builder widget for Tradeoff Analytics

Assuming you have completed the [Application Builder tutorial](http://www.ibm.com/support/knowledgecenter/SS8NLW_10.0.0/com.ibm.swg.im.infosphere.dataexpl.appbuilder.doc/c_de-ab-devapp-tutorial.html) listed in the Prerequisites, you will have some book entities.  Let's add a Tradeoff Analytics widget that will provide book comparisons.

#### Building and configuring a widget that sends queries to the Watson Tradeoff Analytics API

The purpose of this example widget is to send the problem's objectives and options to the Watson Tradeoff Analytics API via the application we created in Bluemix.  The results returned by the Tradeoff Analytics widget will be displayed in the Application Builder UI.  UI controls are provided so end users can make modifications while analyzing the results returned by the widget.

Once you have logged into the Application Builder administrative interface, follow these steps to create the custom widget and add it to the searches page.

1. Navigate to the Pages & Widgets -> searches -> detail page.
2. Create a new Custom widget.
3. Set the ID of the widget to be `WDC_Tradeoff Analytics`
4. Set the Display name of the widget to be `Tradeoff Analytics for Books`
5. Copy and paste the [code for this widget](appbuilder/tradeoff-analytics-widget.erb) into the Type-specific Configuration.
6. Save the widget.
7. Go back to the searches > detail page.
8. Drag the `WDC_Tradeoff Analytics` widget to the top of the middle column and save the page configuration.



**NOTE:** At this point the widget should be fully configured. 


# Implementation Considerations

- **Privacy and Security** - The Tradeoff Analytics widget makes a web request to the Bluemix application endpoint configured in the Application Builder proxy.  In this example, the example Bluemix application is completely open and has no security.
- **Failures will happen** - All distributed systems are inherently unreliable and failures will inevitably occur when attempting to call out to Bluemix.  Consider how failures should be handled.
- **Data Preparation** - It is the responsibility of the caller to ensure that representative data is being sent to the Tradeoff Analytics service.  Additional data preparation may be required in some cases.  Choose content carefully and be sure you are sending a clean news query.
- **Scalability** - This example uses only a single cloud instance with the default Bluemix application settings.  In a production scenario consider how much hardware will be required and adjust the Bluemix application settings accordingly.

## Caching Proxy
Given the considerations listed here, the use of a caching proxy is always recommended in a Production environment.  Using a caching proxy can speed up widget refreshes in some situations and overcome some network failures.


# Licensing
All sample code contained within this project repository or any subdirectories is licensed according to the terms of the MIT license, which can be viewed in the file license.txt.



# Open Source @ IBM
[Find more open source projects on the IBM Github Page](http://ibm.github.io/)

    
