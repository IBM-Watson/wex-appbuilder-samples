#query_similar Endpoint

#Builds complex query for"Query Similar" functionality; returns a link to the search page, with a preseeded query looking for all entities of type this_entity_type that share certain attributes with the current "this_entity_type" entity, or alternatively, the same query but with preselected facets

# Verify params are OK
raise "Missing required paramter: entity_type" unless params[:entity_type]
raise "Missing required parameter: id" unless params[:id]
raise "Missing required parameter: mode - Values: [query_string|query_string_with_facets]" unless params[:mode]
raise "Acceptable values for parameter mode: [query_string|query_string_with_facets]" unless "query_string|query_string_with_facets|".include? params["mode"] + '|'
this_entity_type = params[:entity_type]
this_id = params[:id]
return_mode = params[:mode]

## Utility Methods

# Utility method to return the different "leaf" values found in the hierarchical attribute 
# 'hierachicalAttr1' belonging
# to a test_entity, that begin with level1_value|level2_value
def get_leaf_values(test_entity, hierarchical_attr_name, level1_value, level2_value)
  return test_entity[hierarchical_attr_name].select { |a| a.start_with?(level1_value + '|' + level2_value) }.uniq
end

# Utility method that adds n and k elements to a hash
def add_nk_elements_to_hash(the_hash, n_obj, k_obj)
  unless n_obj.nil? or n_obj.empty?
    the_hash['n'] = n_obj
  end
  unless k_obj.nil? or k_obj.empty?
    the_hash['k'] = k_obj
  end
  return the_hash
end
  

# Utility method to return the data structure that goes in the queryURL (as JSON) 
# to make sure a given refinement widget is selected for a given value
def get_simple_ref_widget_data_struct(widget_name,xPath,logic,the_value)
  
  the_value_hash = {"n" => the_value}
  hash_to_be_returned = {"id" => widget_name, "logic" => logic, "s" => [the_value_hash]}
  hash_to_be_returned['xPath'] = xPath unless xPath.empty?
  return hash_to_be_returned
  
end 

# Utility method to return the data structure that goes in the queryURL (as JSON) 
# to make sure a given refinement widget (that has hierarchical values) is selected for a given value
def get_complex_ref_widget_data_struct(widget_name,xPath,logic,the_value,separator)
  
  hash_to_be_returned = {"id" => widget_name, "logic" => logic, "s" => the_value}
  hash_to_be_returned['xPath'] = xPath unless xPath.empty?
  hash_to_be_returned['separator'] = separator unless separator.empty?
  return hash_to_be_returned
  
end 

# Utility method to return the complex data structure that goes in the queryURL for a
# nested refinement widget
# the_labels has a number of labels separated by separator
# starting from backwards, it adds the label, and the full path to the label
def get_complex_ref_widget_data_structure(the_labels, separator)
  label_array = the_labels.split('|')
  array_of_hashes = []
  until label_array.empty? do
    all_labels = label_array.join('|')
    h = {}
    h = add_nk_elements_to_hash(h,label_array.last, all_labels)
    array_of_hashes << h
    label_array.pop # Remove the last label
  end
  # Now iterate over all the building blocks we've got so far, nesting each element as an "s" in the next hash
  for i in 0 .. array_of_hashes.count - 2
    array_of_hashes[i+1]['s'] = [array_of_hashes[i]]
  end
  return array_of_hashes.last
end

## END Utility Methods

# Now the real thing begins. Customise the search criteria as required

# This query selects the test_entity entity to be used as a starting point
this_test_entity = entity_type(this_entity_type).where(field('id').is(this_id)).first

# Check that we have the basic attributes, otherwise return a basic query

if this_test_entity['simpleAttr1'].nil? or this_test_entity['simpleAttr1'].empty?
    output = URI.encode('../search?q=entityType:test_entity')
else
# Start building the query string: Get the list of test_entity entities that match the simpleAttr1 value of this test_entity (and are not this test_entity)

  similar_test_entities_query_string = '../search?q=simpleAttr1:\''+this_test_entity['simpleAttr1'].first  + '\' AND entityType:test_entity AND NOT(id:'+ this_id+')'

# The following call uses a predefined refinement widget that filters based on the entity type
entity_type_widget_data_struct = get_simple_ref_widget_data_struct('%entityTypes%','','AND',this_entity_type)
# Now will add a refinement based on simpleAttr1. The first argument needs to match the name of 
# an existing refinement widget that refines based on simpleAttr1
simple_attr1_widget_data_struct = get_simple_ref_widget_data_struct('simpleAttr1RefinementWidget','$simpleAttr1','AND',this_test_entity['simpleAttr1'].first)

array_of_values_for_hierarchical_attr1_widget = []
# Now filter by an extra criterion - Having leaf values in the hierachical attribute hierarchicalAttr1 matching the first leaf value starting with 'CCC1|CCC1_2'
leaf_values = get_leaf_values(this_test_entity, 'hierarchicalAttr1','CCC1','CCC1_2')
hierarchical_attr1_complex_data_struct = {}
unless leaf_values.count == 0
  similar_test_entities_query_string << ' AND hierarchicalAttr1:\'' + leaf_values.first + '\''
  hierarchical_attr1_complex_data_struct = get_complex_ref_widget_data_structure(leaf_values.first, '|')
  array_of_values_for_hierarchical_attr1_widget << hierarchical_attr1_complex_data_struct
end


end


# We can finally build the dataStructure for the hierarcharAttr1 widget
hierarchical_attr1_widget_data_struct = []
unless array_of_values_for_hierarchical_attr1_widget.empty?
  # As before, the first argument needs to match the name of an existing search refinement widget
  # that refines based on hierarchicalAttr1
  # The second argument needs to match the name of the attribute
  hierarchical_attr1_widget_data_struct = get_complex_ref_widget_data_struct('hierarchicalAttr1RefinementWidget','$hierarchicalAttr1','AND',array_of_values_for_hierarchical_attr1_widget,'|')
end


# And we are now ready to build the query string including refinements

similar_test_entities_query_string_with_refinements = '../search?button=search&expand_all=false&id=&page=0&q=NOT(id:'+ this_id +')'

# THere always needs to be a selected facet, make sure you use a facet which you know 
# will have a value
selected_tokens_data_struct = {'s' => [simple_attr1_widget_data_struct]}

refinement_tokens_array = []
refinement_tokens_array << entity_type_widget_data_struct # This one is always populated
unless hierarchical_attr1_widget_data_struct.nil? or hierarchical_attr1_widget_data_struct.empty?
  refinement_tokens_array << hierarchical_attr1_widget_data_struct
end

refinement_tokens_data_struct = { 's' => refinement_tokens_array }

similar_test_entities_query_string_with_refinements << '&refinements_token='+ refinement_tokens_data_struct.to_json
 
similar_test_entities_query_string_with_refinements << '&selected_tokens[]='+selected_tokens_data_struct.to_json

similar_test_entities_query_string_with_refinements << '&type=&utf8=✓'



# Check what needs to be returned

case return_mode
when 'query_string' 
  output = URI.escape(similar_test_entities_query_string)
else
    # return the query string including the facetc
  output = URI.escape(similar_test_entities_query_string_with_refinements)
end
 