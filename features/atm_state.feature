Feature: State should return amounts of every bill left in ATM
  Background:
    Given ATM reloaded with such bills:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It return correct amounts
    When I send a GET request to "/v1/atm"
    Then the response status should be "200"
    And the JSON response should have such keys and values:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |
