require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class PortionController
    public
    def self.create(data)
        portion = Portion.create( :name => data['name'], :range => data['range'] )

        portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }

        return portionJson.to_json
    end

    def self.read(data)
        portion = Portion.find(data['id'])

        portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }

        return portionJson.to_json

    end

    def self.update(data)
        portion = Portion.update( data['id'], :name => data['name'], :range => data['range'] )

        portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }

        return portionJson.to_json

    end

    def self.delete(data)
        portion = Portion.find(data['id'])
        portion.destroy

        portionJson = { :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) }

        return portionJson.to_json

    end

    def self.list(data)
        portions = Portion.all

        Array portionJson = Array.new
        portions.each do |portion|
            portionJson.push({ :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, Hash.new) })
        end

        return portionJson.to_json

    end

    def self.filter(data)
        portions = self.filterData(data)

        count = portions.length

        page  = data['Portion']['pagination']['page'].to_i
        limit = data['Portion']['pagination']['limit'].to_i
 
        # Make sure page isn't out of range
        if(page < 1)
            page = 1
        end
 
        if(((page * limit) - limit) > count)
            page = (count / limit).to_i
            if(count % limit > 0)
                page += 1
            end
        end
 
        offset = (page - 1) * limit
        portions = portions.slice(offset, limit)

        Array portionJson = Array.new
        portions.each do |portion|
            portionJson.push({ :id => portion.id, :name => portion.name, :range => portion.range, :reading => ReadingController.recurse(portion.id, data) })
        end

        portionContainer = { :total => count, :portions => portionJson }

        return portionContainer.to_json

    end

    def self.filterData(data)

        portions = []
        if(data.key?("Portion"))
            filters = data['Portion']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    portions = Portion.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    portions = portions & Portion.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return portions
    end

end

