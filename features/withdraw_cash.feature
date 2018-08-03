Feature: Cash withdrawal from ATM
  Background:
    Given ATM has such bills:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 35     |
      | 10 | 678935 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It withdrow requested money
    When I set JSON request body to:
      """
      {"amount": 22}
      """
    And I send a POST request to "/atm"
    Then the response status should be "201"
    And the JSON response should have such nominals and amounts:
      | 2  | 1      |
      | 10 | 2      |

    Then I send a GET request to "/atm"
    And the response status should be "200"
    And the JSON response should have such nominals and amounts:
    # Only amounts of bills with nominal '2' and '10' was changed
      | 1  | 0      |
      | 2  | 2      |
      | 5  | 35     |
      | 10 | 678933 |
      | 25 | 0      |
      | 50 | 123    |

  Scenario: It returns an error on wrong request
    When I set JSON request body to:
      """
      {"OmounD": 22}
      """
    And I send a POST request to "/atm"
    Then the response status should be "400"
    And the JSON response should contain an error "amount is missing"

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


  Scenario: It returns an error when there is no exact notes as needed
    When I set JSON request body to:
      """
      {"amount": 21}
      """
    And I send a POST request to "/atm"
    Then the response status should be "400"
    And the JSON response should contain an error "not enough money to satisfy your request"

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

  Scenario: It returns an error when ATM has lesser money then needed
    Given ATM has such bills:
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 3      |
      | 10 | 0      |
      | 25 | 0      |
      | 50 | 1      |
    When I set JSON request body to:
      """
      {"amount": 100}
      """
    And I send a POST request to "/atm"
    Then the response status should be "400"
    And the JSON response should contain an error "not enough money to satisfy your request"

    Then I send a GET request to "/atm"
    And the response status should be "200"
    And the JSON response should have such nominals and amounts:
    # Not changed at all, the same amounts as was before
      | 1  | 0      |
      | 2  | 3      |
      | 5  | 3      |
      | 10 | 0      |
      | 25 | 0      |
      | 50 | 1      |
