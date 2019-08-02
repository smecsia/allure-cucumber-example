@URGENCY:critical @ISSUE:SEARCH-101
Feature: Google can not search

  Background:
    Given I am on Google

  Scenario: Search for a term
    When I fill in "q" found by "name" with "Something else"
    And I submit
    Then I should see title "Allure - Google Search"
