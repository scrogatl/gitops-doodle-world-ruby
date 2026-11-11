# world.rb
require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    'World from Ruby!'
  end
end
