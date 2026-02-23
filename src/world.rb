# myapp.rb
require 'sinatra/base'

class App < Sinatra::Base
  set :show_execptions, :after_handler

  get '/' do
    'World from Ruby!'
  end
end