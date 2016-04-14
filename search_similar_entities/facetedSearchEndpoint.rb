#QuerySimilar Endpoint

#Builds complex query for"Query Similar" functionality; returns a link to the search page, with a preseeded query looking for all entities of type testEntity that share certain attributes with the current "testEntity" entity, or alternatively, the same query but with preselected facets

# Verify params are OK
raise "Missing required parameter: id" unless params[:id]
raise "Missing required parameter: mode - Values: [queryString|queryStringWithFacets]" unless params[:mode]
raise "Acceptable values for parameter mode: [queryString|queryStringWithFacets]" unless "queryString|queryStringWithFacets|".include? params["mode"] + '|'
thisId = params[:id]
return_mode = params[:mode]

## Utility Methods

# Utility method to return the different "leaf" values found in the hierarchical attribute 
# 'hierachicalAttr1' belonging
# to a testEntity, that begin with level1value|level2value
def getLeafValues(testEntity, level1value, level2value)
  return testEntity['hierarchicalAttr1'].select { |a| a.start_with?(level1value + '|' + level2value) }.uniq
end

# Utility method that adds n and k elements to a hash
def addNKElementsToHash(theHash, nObj, kObj)
  unless nObj.nil? or nObj.empty?
    theHash['n'] = nObj
  end
  unless kObj.nil? or kObj.empty?
    theHash['k'] = kObj
  end
  return theHash
end
  

# Utility method to return the data structure that goes in the queryURL (as JSON) 
# to make sure a given refinement widget is selected for a given value
def getSimpleRefWidgetDataStruct(widgetName,xPath,logic,theValue)
  
  theValueHash = {"n" => theValue}
  tmpHash = {"id" => widgetName, "logic" => logic, "s" => [theValueHash]}
  unless xPath.empty?
    tmpHash['xPath'] = xPath
  end
  return tmpHash
  
end 

# Utility method to return the data structure that goes in the queryURL (as JSON) 
# to make sure a given refinement widget (that has hierarchical values) is selected for a given value
def getComplexRefWidgetDataStruct(widgetName,xPath,logic,theValue,separator)
  
  tmpHash = {"id" => widgetName, "logic" => logic, "s" => theValue}
  unless xPath.empty?
    tmpHash['xPath'] = xPath
  end
  unless separator.empty?
    tmpHash['separator'] = separator
  end
  return tmpHash
  
end 

# Utility method to return the complex data structure that goes in the queryURL for a
# nested refinement widget
# theLabels has a number of labels separated by separator
# starting from backwards, it adds the label, and the full path to the label
def getComplexRefWidgetDataStructure(theLabels, separator)
  labelArray = theLabels.split('|')
  arrayOfHashes = []
  until labelArray.empty? do
    allLabels = labelArray.join('|')
    h = {}
    h = addNKElementsToHash(h,labelArray.last, allLabels)
    arrayOfHashes << h
    labelArray.pop # Remove the last label
  end
  # Now iterate over all the building blocks we've got so far, nesting each element as an "s" in the next hast
  for i in 0 .. arrayOfHashes.count - 2
    arrayOfHashes[i+1]['s'] = [arrayOfHashes[i]]
  end
  return arrayOfHashes.last
end

## END Utility Methods

# Now the real thing begins. Customise the search criteria as required

# This query selects the testEntity entity to be used as a starting point
thisTestEntity = entity_type('testEntity').where(field('id').is(thisId)).first

# Check that we have the basic attributes, otherwise return an basic query

if thisTestEntity['simpleAttr1'].nil? or thisTestEntity['simpleAttr1'].empty?
    output = URI.encode('../search?q=entityType:testEntity')
else
# Start building the query string: Get the list of testEntity entities that match the simpleAttr1 value of this testEntity (and are not this testEntity)

  similarTestEntitiesQueryString = '../search?q=simpleAttr1:\''+thisTestEntity['simpleAttr1'].first  + '\' AND entityType:testEntity AND NOT(id:'+ thisTestEntity['id'].first+')'

# The following call uses a predefined refinement widget that filters based on the entity type
entityTypeWidgetDataStruct = getSimpleRefWidgetDataStruct('%entityTypes%','','AND','testEntity')
# Now will add a refinement based on simpleAttr1. The first argument needs to match the name of 
# an existing refinement widget that refines based on simpleAttr1
simpleAttr1WidgetDataStruct = getSimpleRefWidgetDataStruct('simpleAttr1RefinementWidget','$simpleAttr1','AND',thisTestEntity['simpleAttr1'].first)

arrayOfvaluesForHierarchicalAttr1Widget = []
# Now filter by an extra criterion - Having leaf values in the hierachical attribute hierarchicalAttr1 matching the first leaf value where starting with 'CCC1|CCC1_2'
leafValues = getLeafValues(thisTestEntity,'CCC1','CCC1_2')
hierarchicalAttr1ComplexDataStruct = {}
unless leafValues.count == 0
  similarTestEntitiesQueryString << ' AND hierarchicalAttr1:\'' + leafValues.first + '\''
  hierarchicalAttr1ComplexDataStruct = getComplexRefWidgetDataStructure(leafValues.first, '|')
  arrayOfvaluesForHierarchicalAttr1Widget << hierarchicalAttr1ComplexDataStruct
end


end


# We can finally build the dataStructure for the hierarcharAttr1 widget
hierarchicalAttr1WidgetDataStruct = []
unless arrayOfvaluesForHierarchicalAttr1Widget.empty?
  # As before, the first argument needs to match the name of an existing search refinement widget
  # that refines based on hierarchicalAttr1
  # The second argument needs to match the name of the attribute
  hierarchicalAttr1WidgetDataStruct = getComplexRefWidgetDataStruct('hierarchicalAttr1RefinementWidget','$hierarchicalAttr1','AND',arrayOfvaluesForHierarchicalAttr1Widget,'|')
end


# And we are now ready to build the query string including refinements

similarTestEntitiesQueryStringWithRefinements = '../search?button=search&expand_all=false&id=&page=0&q=NOT(id:'+ thisTestEntity['id'].first+')'

# THere always needs to be a selected facet, make sure you use a facet which you know 
# will have a value
selectedTokensDataStruct = {'s' => [simpleAttr1WidgetDataStruct]}

refinementTokensArray = []
refinementTokensArray << entityTypeWidgetDataStruct # This one is always populated
unless hierarchicalAttr1WidgetDataStruct.nil? or hierarchicalAttr1WidgetDataStruct.empty?
  refinementTokensArray << hierarchicalAttr1WidgetDataStruct
end

refinementTokensDataStruct = { 's' => refinementTokensArray }

similarTestEntitiesQueryStringWithRefinements <<  '&refinements_token='+ refinementTokensDataStruct.to_json
 
similarTestEntitiesQueryStringWithRefinements << '&selected_tokens[]='+selectedTokensDataStruct.to_json

similarTestEntitiesQueryStringWithRefinements << '&type=&utf8=✓'



# Check what needs to be returned

case return_mode
when 'queryString' 
  output = URI.escape(similarTestEntitiesQueryString)
else
    # return the query string including the facetc
  output = URI.escape(similarTestEntitiesQueryStringWithRefinements)
end
 