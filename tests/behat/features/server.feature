Feature: Solr

  @api
  Scenario: Solr server
    Given I am logged in as a user with the "administrator" role
    When I visit "admin/config/search/search-api/add-server"
    And I fill in "name" with "pantheon"
    And I fill in "id" with "pantheon"
    And I press the "Save" button
    When I visit "admin/config/search/search-api/server/pantheon"
    Then I should see "The Solr server could be reached"
    Then I should see "The Solr core could be accessed (latency: "
    Then print current URL

    @api
    Scenario: Index
      Given I am logged in as a user with the "administrator" role
      When I visit "admin/config/search/search-api/add-index"
      And I fill in "name" with "nodes"
      And I fill in "id" with "nodes"
      And I select "Content" from "datasources[]"
      And I select the radio button "pantheon"
      And I press the "Save" button
      When I visit "admin/reports/status"
      And I follow "run cron manually"

    @api
    Scenario: Search Page
      Given I am logged in as a user with the "administrator" role
      When I visit "admin/config/search/search-api-pages/add"
      And I fill in "label" with "content-search"
      And I fill in "id" with "content_search"
      And I select "nodes" from "index"
      And I press the "Next" button
      Then print last response
      And I fill in "path" with "content-search"
      And I press the "Save" button