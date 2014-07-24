require 'date'
require 'json'
require './CustomControllers/Parsha.rb'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class CustomController
    public
    def self.today(data)
        data['date'] = Date.today.strftime('%Y-%m-%d') 
        return self.forDate(data)
    end

    def self.forDate(data)
        portionArray = []

        parshaInfo = Parsha.new().getParsha(data['date'])

        if (parshaInfo.has_key?("code"))
            return parshaInfo.to_json
        else
            portion = Portion.find(parshaInfo['portion'])
            portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }
            portionArray.push(portionJson)
    
            if (parshaInfo['combined'])
                portion = Portion.find(parshaInfo['portion'] + 1)
                portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }
                portionArray.push(portionJson)
            end
            return portionArray.to_json
        end
    end
end

