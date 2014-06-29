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

post '/rest/model/readings/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.create(data)
end

post '/rest/model/readings/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.read(data)
end

post '/rest/model/readings/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.update(data)
end

post '/rest/model/readings/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.delete(data)
end

post '/rest/model/readings/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.list(data)
end

post '/rest/model/readings/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    ReadingController.filter(data)
end

post '/rest/model/verses/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.create(data)
end

post '/rest/model/verses/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.read(data)
end

post '/rest/model/verses/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.update(data)
end

post '/rest/model/verses/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.delete(data)
end

post '/rest/model/verses/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.list(data)
end

post '/rest/model/verses/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    VerseController.filter(data)
end

# Rest Routes (POST)
