When(/^I send a GET request to "(.*?)"$/) do |local_path|
  visit local_path
end

Then(/^the response status should be "(\d+)"$/) do |status_code|
  expect(page.status_code).to eq(status_code)
end

Given('ATM reloaded with such bills:') do |bills|
  bills.rows_hash.each do |bill, amount|
    Bill.find(bill).update_attribute :amount, amount
  end
end

Then('the JSON response should have such keys and values:') do |bills|
  parsed_body = JSON.parse(page.body)

  bills.rows_hash.each do |bill, amount|
    amount_from_response = parsed_body.select { |item| item['nominal'] == bill.to_i }.first['amount']
    expect(amount_from_response).to eq(amount.to_i)
  end
end
