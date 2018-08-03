# System Requirements

* ruby 2.0+
* sqlite3

# Installation

* `bundle install`
* `rake db:migrate db:seed`
* `RACK_ENV=test rake db:migrate db:seed`
* `rspec`
* `cucumber --order random`

#Instructions

- You can then visit the api at the following endpoints

http://localhost:9292/atm - get atm state

- You can withdraw from atm like so:

curl -X POST "http://localhost:9292/atm"
