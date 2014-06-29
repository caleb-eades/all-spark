require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class ReadingController
    public
    def self.create(data)
        reading = Reading.create( :range => data['range'], :portion_id => data['portion_id'] )

        readingJson = { :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, Hash.new) }

        return readingJson.to_json
    end

    def self.read(data)
        reading = Reading.find(data['id'])

        readingJson = { :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, Hash.new) }

        return readingJson.to_json

    end

    def self.update(data)
        reading = Reading.update( data['id'], :range => data['range'] )

        readingJson = { :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, Hash.new) }

        return readingJson.to_json

    end

    def self.delete(data)
        reading = Reading.find(data['id'])
        reading.destroy

        readingJson = { :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, Hash.new) }

        return readingJson.to_json

    end

    def self.list(data)
        readings = Reading.all

        Array readingJson = Array.new
        readings.each do |reading|
            readingJson.push({ :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, Hash.new) })
        end

        return readingJson.to_json

    end

    def self.recurse(portion_id, data)
        if(data.key?("Reading"))
            readings = Reading.where(:portion_id => portion_id) & self.filterData(data)
        else
            readings = Reading.where(:portion_id => portion_id)
        end

        Array readingJson = Array.new
        readings.each do |reading|
            readingJson.push({ :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, data) })
        end

        return readingJson

    end

    def self.filter(data)
        readings = self.filterData(data)

        count = readings.length

        page  = data['Reading']['pagination']['page'].to_i
        limit = data['Reading']['pagination']['limit'].to_i
 
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
        readings = readings.slice(offset, limit)

        Array readingJson = Array.new
        readings.each do |reading|
            readingJson.push({ :id => reading.id, :range => reading.range, :verse => VerseController.recurse(reading.id, data) })
        end

        readingContainer = { :total => count, :readings => readingJson }

        return readingContainer.to_json

    end

    def self.filterData(data)

        readings = []
        if(data.key?("Reading"))
            filters = data['Reading']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    readings = Reading.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    readings = readings & Reading.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return readings
    end

end

