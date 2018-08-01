require_relative '../../config/application.rb'

class Atm < Grape::API
  version 'v1', using: :path
  format :json

  resource :atm do
    desc 'Get atm leftovers'
    get '/' do
      nil
    end

    desc 'Withdraw cash'
    post '/' do
      nil
    end

    desc 'Reload cash'
    put '/' do
      nil
    end
  end
end
