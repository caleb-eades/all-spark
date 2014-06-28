require 'sinatra'
require "sinatra/config_file"
require 'json'
require 'active_record'

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
post '/rest/model/portions/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.create(data)
end

post '/rest/model/portions/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.read(data)
end

post '/rest/model/portions/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.update(data)
end

post '/rest/model/portions/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.delete(data)
end

post '/rest/model/portions/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.list(data)
end

post '/rest/model/portions/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    PortionController.filter(data)
end

# Rest Routes (POST)
