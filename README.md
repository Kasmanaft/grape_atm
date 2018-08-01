#Instructions

- Run the following commands to get started

1. rake db:create
4. rackup

- You can then visit the api at the following endpoints

http://localhost:9292/atm - get atm state

- You can withdraw from atm like so:

curl -X POST "http://localhost:9292/atm"
