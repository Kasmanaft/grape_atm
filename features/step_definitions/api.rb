When(/^I send a GET request to "(.*?)"$/) do |local_path|
  visit local_path
end

Then(/^the response status should be "(\d+)"$/) do |status_code|
  expect(page.status_code).to eq(status_code)
end

Given('ATM has such bills:') do |bills|
  bills.rows_hash.each do |bill, amount|
    Bill.find(bill).update_attribute :amount, amount
  end
end

Then('the JSON response should have such nominals and amounts:') do |bills|
  parsed_body = JSON.parse(page.body)

  bills.rows_hash.each do |nominal, amount|
    amount_from_response = parsed_body.select { |item| item['nominal'] == nominal.to_i }.first['amount']
    expect(amount_from_response).to eq(amount.to_i)
  end
end

When('I set JSON request body to:') do |request_body|
  @request_body = request_body
end

When(/^I send a (PUT|POST) request to "(.*?)"$/) do |method, local_path|
  page.driver.browser.send(method.downcase, local_path, JSON.parse(@request_body).as_json)
end

Then('the JSON response should be ok') do
  expect(page.body).to eq('{"status":"Ok"}')
end

Then('the JSON response should contain an error {string}') do |expected_error|
  parsed_body = JSON.parse(page.body)
  expect(parsed_body['error']).to eq(expected_error)
end
