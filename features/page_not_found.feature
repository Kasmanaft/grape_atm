Feature: page not found
  Scenario: The user tries to access a non-existent endpoint
    When I send a GET request to "http://localhost:9293/"
    Then the response status should be "404"
