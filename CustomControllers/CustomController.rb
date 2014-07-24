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

        parshaInfo = Parsha.new().getParsha(data['date'])

        if (parshaInfo.has_key?("code"))
            return parshaInfo.to_json
        end
        #portion = Portion.find(parshaInfo['portion'])

        #portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }

        #return portionJson.to_json
        return "YAY"
    end
end

