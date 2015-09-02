# Save Current Search Results Page widget #

# Description and Use #

This widget is designed to be used on the search results page within App Builder.

The intention is to save the current url to the current_user.properties in zookeeper. We create a new store called current_user.properties["saved_searches"]. This property accepts a key/value pair. The key is a lable defined by the user and the value is always the applications current url. Currently if the user enters a key that already exists the current entry is updated.

We save the current relative url and params. This allows the user to select refinements, pages, etc and save the exact state of the page they are on.

![Screenshot](saved_search_screenshot_2.png)
