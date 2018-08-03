require_relative '../../config/application.rb'

class Atm < Grape::API
  format :json

  resource :atm do
    desc 'Get atm leftovers'
    get '/' do
      Bill.all
    end

    desc 'Reload cash'
    params do
      require_relative '../models/bill.rb' # uninitialized constant Bill (NameError) otherwise
      requires :bills, type: Array[JSON] do
        requires :nominal, type: Integer, desc: 'Bill Nominal',
                           values: Bill::AVAILABLE_NOMINALS
        requires :amount, type: Integer, desc: 'Amount of Bills'
      end
    end
    put '/' do
      Bill.reload params[:bills]
      { status: 'Ok' }
    end

    desc 'Withdraw cash'
    params do
      requires :amount, type: Integer, desc: 'Cash Amount', except_values: [0]
    end
    post '/' do
      result = Bill.withdraw params[:amount]
      status 400 unless result.is_a?(Array) # Error will be returned in hash
      result
    end
  end
end
