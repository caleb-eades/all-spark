require 'sinatra'
require "sinatra/config_file"
require 'json'
require 'active_record'

require './Router.rb'

config_file 'config/settings.yml'
Dir["./ViewControllers/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

Dir["./ModelControllers/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

config = JSON::load(File.open(settings.configName))

# HTML static routes (GET)
ActiveRecord::Base.establish_connection(
    :adapter => config['adapter'],
    :host => config['host'],
    :port => config['port'],
    :username => config['username'],
    :password => config['password'],
    :database => config['database'],
    :pool => 100
)

# Model REST routes (POST)
post '/rest/logic/portion/today' do
#    request.body.rewind
#    data = JSON.parse request.body.read
#    content_type :json
#    PortionController.create(data)
    return "Hello world"
end

