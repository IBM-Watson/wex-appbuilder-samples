# Search similar entities

This reusable asset adds the capability of searching for similar entities to a given one. 
This can be added as a button on an entity detail page. The button will open the search page
with some query criteria predefined (and, optionally, refinement widgets pre-selected)
Having the search page results with preset refinements widget makes it more usable for an end user,
as they can easily add or remove refinements to continue their search for similar matter.

## Reusable assets

1. facetedSearchEndpoint.rb: Sample code for an endpoint. This assumes that the entity searched is of type `testEntity`, and that the similarity criteria between entities are based on having the same value for the attribute simpleAttr1, as well
as having the same leaf value on a 3-level hierarchical attribute, hierarchicalAttr1.The search criteria can be modified to suit other entities and criteria
2. searchSimilarEntitiesWidget.html: Sample custom widget that can be added to the entity detail page. It shows 2 buttons: One opens the search page with the query string pre-loaded. The second one opens the search page with the same criteria, but instead
of having the query string pre-loaded, it presets refinement widgets.


## Steps to run this example

1. Engine
  a. Create a test collection
  b. Add any single file as a seed
  c. Add a custom XSL conversor using generateTestEntity.xsl. This will create 2 entities of type testEntity
  d. Make the following attributes fastIndexed: id, simpleAttr1, simpleAttr2, hierarchicalAttr1
  e. Crawl the collection

2. AppBuilder
  a. Add a new entity called testEntity, based on the test collection
  b. In the search page, add the following refinement widgets:
    - simpleAttr1RefinementWidget: Refine by field: field('simpleAttr1')
    - simpleAttr2RefinementWidget: Refine by field: field('simpleAttr2')
    - hierarchicalAttr1RefinementWidget: Refine by field: field('hierarchicalAttr1').with_and_logic.with_separator('|').without_pruning
  c. Add an endpoint called facetedSearch. Use the sample code: facetedSearchEndpoint.rb
  d. In the detail page for the entity testEntity, add a custom widget using the sample code: searchSimilarEntitiesWidget.html

3. To test: Open the detail page for testEntity with id: 1. When clicking on any of the buttons, the search page should open showing as results 
another entity (id:2). Depending on the button selected the search criteria will appear eithear as query string in the search box, or as 
preselected facets.

![The entity detail page with the search buttons](EntityDetailPageWithSearchButton.tiff)
![The search page with the query as a string in the search box](InvokingSearchPageWithQueryString.tiff)
![The search page with the query as selected refinements](InvokingSearchPageWithRefinements.tiff)
