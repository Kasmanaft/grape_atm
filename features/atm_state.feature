Feature: State should return amounts of every bill left in ATM
  Background:
    Given ATM has such bills:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It return correct amounts
    When I send a GET request to "/atm"
    Then the response status should be "200"
    And the JSON response should have such nominals and amounts:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |
