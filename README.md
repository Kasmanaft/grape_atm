# System Requirements

* ruby 2.0+
* sqlite3

# Installation

* `bundle install`
* `rake db:migrate db:seed`
* `RACK_ENV=test rake db:migrate db:seed`
* `rspec`
* `cucumber --order random`

# Instructions

You can then visit the api at the following endpoints (GET request)
http://localhost:9292/atm - **get ATM state**, will return JSON like:

    [
     {"nominal": 1, "amount": 2},
     {"nominal": 2, "amount": 12}
    ]

You can **withdraw from ATM** with POST request "http://localhost:9292/atm" with
JSON body like this:

    {"amount": 234}
    
In case of success, it will return JSON like this one:

    [
     {"nominal": 2, "amount": 2},
     {"nominal": 5, "amount": 1},
     {"nominal": 25, "amount": 1},
     {"nominal": 50, "amount": 4}
    ]
    
Otherwise, it will return error like this one:

    { "error": "not enough money to satisfy your request" }

You can **reload ATM** with PUT request "http://localhost:9292/atm" with
JSON body like this:

    {"bills" :[
     {"nominal": 10, "amount": 20},
     {"nominal": 50, "amount": 200}
    ]}
    
In case of success, it will return JSON like this one:

    { "status": "Ok" }
    
Otherwise, it will return error like this one:

    { "error": "error message" }
