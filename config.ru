require 'rubygems'
require 'sinatra.rb'

# Sinatra defines #set at the top level as a way to set application configuration
set :views, File.join(File.dirname(__FILE__), 'app','views')
set :run, false
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)

require 'app/main'  
run Sinatra.application