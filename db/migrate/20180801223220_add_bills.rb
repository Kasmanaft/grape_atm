class AddBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills, id: false do |t|
      t.integer :nominal, null: false, auto_increment: false, primary_key: true
      t.integer :amount, null: false, default: 0
    end
  end
end
