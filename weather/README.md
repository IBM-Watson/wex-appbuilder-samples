# Simple Weather Widget #

# Description and Use #

This is a simple weather widget that does not rely on an endpoint.  See the widget `weather_endpoint`
for a version of this widget that uses an endpoint.

The widget relies on a div having class `weather` with a `data` attribute for `zip`.  This data attribute should be set
to the zipcode of the target location.  You may have more than one weather displayed by adding another div with the class and data
attributes set.

![Screenshot](weather_screenshot.png)

This wigdet gets the weather via a YQL query to the Yahoo! Weather API.
