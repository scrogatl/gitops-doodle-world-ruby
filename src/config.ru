# config.ru

ENV['APP_ENV'] = 'production' # https://community.fly.io/t/attack-prevented-by-rack-hostauthorization/22992/2

require 'bundler'

Bundler.require 

require './world'
require './opentelemetry'
# require 'opentelemetry/sdk'
# require 'opentelemetry/exporter/otlp'
# require 'opentelemetry/instrumentation/all'

# run Sinatra::Application
Rack::Handler.default.run(App, :Host => "0.0.0.0", :Port => 5003)
