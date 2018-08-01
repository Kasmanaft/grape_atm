require_relative '../../config/application.rb'

class Atm < Grape::API
  version 'v1', using: :path
  format :json

  resource :atm do
    desc 'Get atm leftovers'
    get '/' do
      User.sorted_by_first_name.to_json
    end

    desc 'Withdraw cash'
    post '/' do
      User.sorted_by_created_at.to_json
    end

    desc 'Reload cash'
    put '/' do
      User.sorted_by_last_name.to_json
    end
  end
end
