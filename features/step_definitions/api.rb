When(/^I send a GET request to "(.*?)"$/) do |local_path|
  visit local_path
end

Then(/^the response status should be "(\d+)"$/) do |status_code|
  expect(page.status_code).to eq(status_code)
end
