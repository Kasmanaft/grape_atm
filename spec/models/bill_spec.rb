describe Bill do
  describe '.reload' do
    it 'uses transaction' do
      expect(Bill).to receive(:transaction).once
      Bill.reload([{ 'nominal' => 1, 'amount' => 1 }])
    end

    it 'adds defined amount to bills of such nominal' do
      expect { Bill.reload([{ 'nominal' => 25, 'amount' => 3 }]) }.to change {
        Bill.find(25).amount
      }.by(3)
    end

    it 'doesn\'t adds anything to not defined nominal' do
      expect { Bill.reload([{ 'nominal' => 25, 'amount' => 13 }]) }.not_to change {
        Bill.find(5).amount
      }
    end
  end

  describe '.reformat' do
    it 'converts from Hash to Array' do
      source = { 1 => 2, 2 => 17 }
      expected = [{ 'nominal' => 1, 'amount' => 2 }, { 'nominal' => 2, 'amount' => 17 }]
      expect(Bill.reformat(source)).to eql(expected)
    end
  end

  describe '.calculate_bills' do
    context 'there is enough money in ATM' do
      before do
        Bill.find(50).update_attribute(:amount, 12_000)
        Bill.find(25).update_attribute(:amount, 0)
        Bill.find(10).update_attribute(:amount, 0)
        Bill.find(5).update_attribute(:amount, 0)
        Bill.find(2).update_attribute(:amount, 12_000)
      end

      it 'returns only bills of one kind, if requested amount divides without remnant' do
        bills, _leftovers = Bill.calculate_bills(100)
        expect(bills.size).to eq(1)
      end

      it 'returns only top bills of one kind, if requested amount divides without remnant' do
        bills, _leftovers = Bill.calculate_bills(100)
        expect(bills[50]).to eq(2)
      end

      it 'doesn\'t return leftovers, if there is no bills with exact amount as requested' do
        _bills, leftovers = Bill.calculate_bills(10)
        expect(leftovers).to eq(0)
      end

      it 'returns top bills of one kind, if requested amount divides without remnant and there is no bills with exact amount as requested' do
        bills, _leftovers = Bill.calculate_bills(10)
        expect(bills[2]).to eq(5)
      end
    end

    context 'there is NO enough money in ATM' do
      before do
        Bill.find(50).update_attribute(:amount, 0)
        Bill.find(25).update_attribute(:amount, 0)
        Bill.find(10).update_attribute(:amount, 0)
        Bill.find(5).update_attribute(:amount, 0)
        Bill.find(2).update_attribute(:amount, 2)
        Bill.find(1).update_attribute(:amount, 0)
      end

      it 'returns leftovers >0 if total amount in ATM lesser then requested' do
        _bills, leftovers = Bill.calculate_bills(10)
        expect(leftovers).to be > 0
      end

      it 'returns leftovers >0 if there is no exact notes as needed' do
        _bills, leftovers = Bill.calculate_bills(3)
        expect(leftovers).to be > 0
      end
    end
  end

  describe '.withdrow' do
    it 'uses transaction' do
      Bill.find(1).update_attribute(:amount, 12)
      expect(Bill).to receive(:transaction).once
      Bill.withdraw(1)
    end

    it 'calls .calculate_bills to calculate amounts of bills of each kind' do
      expect(Bill).to receive(:calculate_bills).once.and_return([{}, 2])
      Bill.withdraw(1)
    end

    it 'return an error if calculate_bills returns leftovers > 0' do
      allow(Bill).to receive(:calculate_bills).and_return([{}, 2])
      expected_error = { error: 'not enough money to satisfy your request' }
      expect(Bill.withdraw(1)).to eq expected_error
    end

    it 'calls .reformat if there is no error' do
      allow(Bill).to receive(:calculate_bills).and_return([{ 1 => 1 }, 0])
      expect(Bill).to receive(:reformat).once.and_return([{ 'nominal' => 1, 'amount' => 1 }])
      Bill.withdraw(1)
    end

    it 'decrease amount of bill, returned from calculate_bills' do
      Bill.find(1).update_attribute(:amount, 12)
      allow(Bill).to receive(:calculate_bills).and_return([{ 1 => 3 }, 0])
      allow(Bill).to receive(:reformat).once.and_return([{ 'nominal' => 1, 'amount' => 3 }])

      # Doesn't matter how much we request, because we mocked .calculate_bills above
      expect { Bill.withdraw(1) }.to change {
        Bill.find(1).amount
      }.from(12).to(9)
    end

    it 'returns amount of bill, returned from calculate_bills' do
      Bill.find(1).update_attribute(:amount, 12)
      allow(Bill).to receive(:calculate_bills).and_return([{ 1 => 3 }, 0])
      expected_result = [{ 'nominal' => 1, 'amount' => 3 }]
      allow(Bill).to receive(:reformat).once.and_return(expected_result)
      expect(Bill.withdraw(1)).to eq expected_result
    end
  end
end
