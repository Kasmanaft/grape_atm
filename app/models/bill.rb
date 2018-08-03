class Bill < ActiveRecord::Base
  self.primary_key = :nominal

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
    amount
  end
end
