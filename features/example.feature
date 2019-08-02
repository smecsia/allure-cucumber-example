@SEVERITY:trivial @ISSUE:SEARCH-100
Feature: Google can search

  Background:
    Given I am on Google

  Scenario: Search for a term
    When I fill in "q" found by "name" with "Allure"
    And I submit
    Then I should see title "Allure - Google Search"
