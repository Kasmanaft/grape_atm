class Bill < ActiveRecord::Base
  self.primary_key = :nominal

  AVAILABLE_NOMINALS = [1, 2, 5, 10, 25, 50].freeze

  def self.reload(bills)
    Bill.transaction do
      bills.each do |bill|
        old = find(bill['nominal'])
        old.amount += bill['amount']
        old.save!
      end
    end
  end

  def self.withdraw(amount)
    Bill.transaction do
      bills, leftover = calculate_bills(amount)

      return { error: 'not enough money to satisfy your request' } if leftover > 0

      bills = reformat(bills)
      bills.each do |bill|
        old = find(bill['nominal'])
        old.amount -= bill['amount']
        old.save!
      end
      bills
    end
  end

  def self.calculate_bills(amount)
    bills = {}
    AVAILABLE_NOMINALS.sort.reverse.each do |nominal|
      next if amount < nominal

      bill_amount_in_atm = Bill.find(nominal).amount
      next if bill_amount_in_atm == 0

      bill_amount = amount / nominal
      new_amount = amount % nominal

      if bill_amount_in_atm >= bill_amount
        bills[nominal] = bill_amount
      else
        leftover = bill_amount - bill_amount_in_atm
        bills[nominal] = bill_amount_in_atm
        new_amount += (leftover * nominal)
      end

      amount = new_amount
      break if amount == 0
    end
    [bills, amount]
  end

  def self.reformat(bills)
    # converts Hash from {1 => 2, 2 => 12} to
    # Array [{"nominal" => 1, "amount" => 2}, {"nominal" => 2, "amount" => 12}]'

    bills.to_a.map do |bill|
      { 'nominal' => bill[0], 'amount' => bill[1] }
    end
  end
end
