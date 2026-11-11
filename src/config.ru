# config.ru

ENV['APP_ENV'] = 'production' # https://community.fly.io/t/attack-prevented-by-rack-hostauthorization/22992/2

require 'bundler'

# APM_FLAVOR is set by the Dockerfile target: plain | newrelic | otel.
# It decides which optional gem group is loaded; the app itself is identical.
flavor = ENV.fetch('APM_FLAVOR', 'plain')
Bundler.require(:default, flavor.to_sym)

require './world'
require './opentelemetry' if flavor == 'otel'

run App
