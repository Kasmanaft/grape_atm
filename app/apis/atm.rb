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
      requires :bills, type: Array[JSON] do
        requires :nominal, type: Integer, desc: 'Bill Nominal', values: [1, 2, 5, 10, 25, 50]
        requires :amount, type: Integer, desc: 'Amount of Bills'
      end
    end
    put '/' do
      Bill.reload params[:bills]
      { status: 'Ok' }
    end

    desc 'Withdraw cash'
    params do
      requires :amount, type: Integer, desc: 'Amount of Bills'
    end
    post '/' do
      Bill.withdraw params[:amount]
    end
  end
end
