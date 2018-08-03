Feature: Cash reloaded into ATM
  Background:
    Given ATM has such bills:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It adds all bills from request
    When I set JSON request body to:
      """
      {"bills": [
        {"nominal": 1, "amount": 1},
        {"nominal": 2, "amount": 13},
        {"nominal": 5, "amount": 0},
        {"nominal": 10, "amount": 22},
        {"nominal": 25, "amount": 0},
        {"nominal": 50, "amount": 12345}
      ]}
      """
    And I send a PUT request to "/atm"
    Then the response status should be "200"
    And the JSON response should be ok

    Then I send a GET request to "/atm"
    And the response status should be "200"
    And the JSON response should have such nominals and amounts:
      | 1  | 1      |
      | 2  | 16     |
      | 5  | 35     |
      | 10 | 678957 |
      | 25 | 0      |
      | 50 | 12468  |

  Scenario: It sends request with wrong nominal
    When I set JSON request body to:
      """
      {"bills": [
        {"nominal": 13, "amount": 16},
        {"nominal": 2, "amount": 13},
        {"nominal": 5, "amount": 0},
        {"nominal": 10, "amount": 22},
        {"nominal": 25, "amount": 0},
        {"nominal": 50, "amount": 12345}
      ]}
      """
    And I send a PUT request to "/atm"
    Then the response status should be "400"
    And the JSON response should contain an error

    Then I send a GET request to "/atm"
    And the response status should be "200"
    And the JSON response should have such nominals and amounts:
    # Not changed at all, the same amounts as was before
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It sends valid request with just a few nominals (not all)
    When I set JSON request body to:
      """
      {"bills": [
        {"nominal": 2, "amount": 13},
        {"nominal": 5, "amount": 0}
      ]}
      """
    And I send a PUT request to "/atm"
    Then the response status should be "200"
    And the JSON response should be ok

    Then I send a GET request to "/atm"
    And the response status should be "200"
    And the JSON response should have such nominals and amounts:
    # Only amounts of bills with nominal '2' was changed
      | 1  | 0      |
      | 2  | 16     |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |
