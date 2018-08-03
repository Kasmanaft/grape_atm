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
end
